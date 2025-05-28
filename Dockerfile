FROM docker.io/library/debian:trixie-slim
ARG DEBIAN_FRONTEND=noninteractive

# don't need to pin apt package versions
# hadolint ignore=DL3008
RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
rm -f /etc/apt/apt.conf.d/docker-clean && \
apt-get update && \
apt-get install --yes --no-install-recommends \
    curl ca-certificates rustup make jq build-essential \
    python3 libx11-xcb-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render0-dev && \
useradd --create-home user && \
mkdir /app && \
chown -R user:user /app

USER user
WORKDIR /app

COPY --chown=user:user ./rust-toolchain .
RUN xargs rustup toolchain install < rust-toolchain

COPY --chown=user:user ./Cargo.toml ./Cargo.lock .
RUN \
mkdir src && \
touch src/main.rs && \
cargo fetch && \
rm -r src

# RUN STUFF HERE
