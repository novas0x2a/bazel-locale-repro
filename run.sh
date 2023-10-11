#!/bin/bash

set -euo pipefail

PLATFORM=${1:-arm64}

env DOCKER_BUILDKIT=1 docker build --platform "$PLATFORM" --progress plain .
