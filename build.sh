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
PLATFORMS="linux/amd64,linux/arm64"

NO_CACHE=""
[[ "${1:-}" == "--no-cache" ]] && NO_CACHE="--no-cache"

echo "Building ${IMAGE_NAME} for platforms: ${PLATFORMS}"

docker buildx build \
  ${NO_CACHE} \
  --platform "${PLATFORMS}" \
  --tag "${IMAGE_NAME}:latest" \
  --tag "${IMAGE_NAME}:${VERSION_TAG}" \
  --file "${SCRIPT_DIR}/Dockerfile" \
  --push \
  "${SCRIPT_DIR}"

echo ""
echo "Pushed:"
echo "  ${IMAGE_NAME}:latest"
echo "  ${IMAGE_NAME}:${VERSION_TAG}"
