FROM docker.io/library/debian:trixie-slim
ARG DEBIAN_FRONTEND=noninteractive

COPY ./ci/Aptfile /opt/Aptfile
RUN --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
rm -f /etc/apt/apt.conf.d/docker-clean && \
apt-get update && \
xargs apt-get install --yes --no-install-recommends < /opt/Aptfile && \
useradd --create-home user && \
mkdir /app && \
chown -R user:user /app

USER user
WORKDIR /app

COPY --chown=user:user ./rust-toolchain .
RUN xargs rustup toolchain install < rust-toolchain

COPY --chown=user:user ./Cargo.toml ./Cargo.lock ./
RUN \
mkdir src && \
touch src/main.rs && \
cargo fetch && \
rm -r src

COPY --chown=user:user . .
CMD [ "make", "dist/bin/askii" ]
