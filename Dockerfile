FROM debian:12.2@sha256:7d3e8810c96a6a278c218eb8e7f01efaec9d65f50c54aae37421dc3cbeba6535

RUN apt update
RUN apt install -y gcc python3 wget

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN mkdir -p /usr/src

WORKDIR /usr/src

RUN \
    case "$(uname -m)" in \
        aarch64) file=bazelisk-linux-arm64 ;; \
        x86_64)  file=bazelisk-linux-amd64 ;; \
        *)       echo "unknown CHOST" >&2; exit 1;; \
    esac \
    && wget https://github.com/bazelbuild/bazelisk/releases/download/v1.18.0/$file \
    && mv $file bazel \
    && chmod +x bazel

RUN env USE_BAZEL_VERSION=6.3.2 ./bazel version \
    && env USE_BAZEL_VERSION=6.4.0rc1 ./bazel version

ENV USE_BAZEL_VERSION=6.4.0rc1

COPY BUILD.bazel WORKSPACE.bazel .

RUN \
    ls -l \
    && locale \
    && locale -a \
    && ./bazel info release \
    && ./bazel build //...
