#!/usr/bin/env bash
# Builds and pushes the claude-container Docker image.
#
# Usage:
#   ./build.sh [--no-cache]
#
# Options:
#   --no-cache   Force full rebuild (picks up new claude/kubectl/gh versions)
#
# Requires: docker buildx with multi-platform support
#   docker buildx create --use --name multiarch --driver docker-container

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
IMAGE_NAME="ghcr.io/eliasmeireles/claude-container"
VERSION_TAG="$(date +%Y%m%d)"

NO_CACHE=""
[[ "${1:-}" == "--no-cache" ]] && NO_CACHE="--no-cache"

for ARCH in amd64 arm64; do
  echo "Building ${IMAGE_NAME} for linux/${ARCH}"

  docker buildx build \
    ${NO_CACHE} \
    --platform "linux/${ARCH}" \
    --tag "${IMAGE_NAME}:latest-${ARCH}" \
    --tag "${IMAGE_NAME}:${VERSION_TAG}-${ARCH}" \
    --file "${SCRIPT_DIR}/Dockerfile" \
    --push \
    "${SCRIPT_DIR}"

  echo ""
  echo "Pushed:"
  echo "  ${IMAGE_NAME}:latest-${ARCH}"
  echo "  ${IMAGE_NAME}:${VERSION_TAG}-${ARCH}"
  echo ""
done
