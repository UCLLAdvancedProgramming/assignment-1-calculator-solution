FROM mcr.microsoft.com/devcontainers/base:jammy

ARG GLEAM_VERSION="v1.0.0-rc2"

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get -y install --no-install-recommends erlang rebar3 2>&1 \
  && curl -sSL https://github.com/gleam-lang/gleam/releases/download/${GLEAM_VERSION}/gleam-${GLEAM_VERSION}-x86_64-unknown-linux-musl.tar.gz -o gleam.tar.gz \
  && tar xvf gleam.tar.gz -C /usr/local/bin \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  && rm gleam.tar.gz