NAME := $(shell cargo read-manifest | jq -r ".name")
VERSION := $(shell cargo read-manifest | jq -r ".version" | sed 's/-/_/')
DESCRIPTION := $(shell cargo read-manifest | jq ".description")
AUTHOR := $(shell cargo read-manifest | jq ".authors[]")
TAG=v$(VERSION)

DIST=dist

BIN=$(NAME)
DEB=$(NAME)_$(VERSION)_amd64.deb
RPM=$(NAME)-$(VERSION)-1.x86_64.rpm
PAC=$(NAME)-$(VERSION)-1-x86_64.pkg.tar.xz

BINPATH=$(DIST)/bin/$(BIN)
DEBPATH=$(DIST)/$(DEB)
RPMPATH=$(DIST)/$(RPM)
PACPATH=$(DIST)/$(PAC)
OSXPATH=$(DIST)/osx/$(BIN)

CI_IMAGE=askii-ci

.PHONY: all
all: $(BINPATH) $(DEBPATH) $(RPMPATH) $(PACPATH)

$(BINPATH):
	cargo build --release --frozen
	mkdir -p $(DIST)/bin
	cp target/release/$(BIN) $(BINPATH)

$(DEBPATH): $(BINPATH)
	cd $(DIST) && fpm -s dir -t deb --prefix /usr -n $(NAME) -v $(VERSION) --description $(DESCRIPTION) --maintainer $(AUTHOR) --vendor $(AUTHOR) -d "libxcb1" -d "libxcb-render0" -d "libxcb-shape0" -d "libxcb-xfixes0" -d "libxau6" -d "libxdmcp6" -d libc6 --license MIT -f --deb-priority optional --deb-no-default-config-files bin/$(BIN)

$(RPMPATH): $(BINPATH)
	cd $(DIST) && fpm -s dir -t rpm --prefix /usr -n $(NAME) -v $(VERSION) --description $(DESCRIPTION) --maintainer $(AUTHOR) --vendor $(AUTHOR) -d "libxcb >= 1" --license MIT -f bin/$(BIN)

$(PACPATH): $(BINPATH)
	cd $(DIST) && fpm -s dir -t pacman --prefix /usr -n $(NAME) -v $(VERSION) --description $(DESCRIPTION) --maintainer $(AUTHOR) --vendor $(AUTHOR) -d "libxcb" --license MIT -f bin/$(BIN)

OSX_PREFIX=/usr/local/osx-ndk-x86

$(OSXPATH):
	mkdir -p $(DIST)/osx
	PKG_CONFIG_ALLOW_CROSS=1 PATH=$(OSX_PREFIX)/bin:$$PATH LD_LIBRARY_PATH=$(OSX_PREFIX)/lib cargo build --target=x86_64-apple-darwin --release --frozen
	cp target/x86_64-apple-darwin/release/$(BIN) $(OSXPATH)

.PHONY: cross
cross: $(OSXPATH)

.PHONY: everything
everything: all cross

.PHONY: build
build: $(BINPATH)

.PHONY: distclean
distclean:
	rm -rf $(DIST)

.PHONY: clean
clean: distclean
	cargo clean

.PHONY: dev-clippy
dev-clippy:
	cargo watch -c -x clippy

.PHONY: dev-install
dev-install:
	cargo watch -c -x "install --path . --force"

.PHONY: install
install:
	cargo install --path . --force

.PHONY: ci-env
ci-env:
	docker build --tag $(CI_IMAGE) --file ci/Dockerfile .

.PHONY: ci-shell
ci-shell: ci-env
	docker run --rm -it $(CI_IMAGE) /bin/bash

.PHONY: ci
ci: ci-env
	docker container rm --force $(CI_IMAGE) || true
	docker container run --network none --name $(CI_IMAGE) $(CI_IMAGE)
	rm -rf $(DIST)
	docker container cp "$(CI_IMAGE):/app/$(DIST)/" $(DIST)

.PHONY: release
release:
	test "$(shell git branch --show-current)" == master
	git pull --ff-only
	git tag "$(TAG)"
	git push --tags
