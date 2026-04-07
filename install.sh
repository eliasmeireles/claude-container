#!/usr/bin/env bash
# Installs claude-container: copies the runner script to ~/.local/bin and pulls the Docker image.

set -euo pipefail

IMAGE="ghcr.io/eliasmeireles/claude-container:latest"
BIN_DIR="${HOME}/.local/bin"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "${BIN_DIR}"

cp "${SCRIPT_DIR}/bin/claude-container" "${BIN_DIR}/claude-container"
chmod +x "${BIN_DIR}/claude-container"

echo "Pulling ${IMAGE}..."
docker pull "${IMAGE}"

echo ""
echo "Installation complete!"
echo ""
echo "Make sure ${BIN_DIR} is in your PATH:"
echo "  export PATH=\"\${HOME}/.local/bin:\${PATH}\""
echo ""
echo "Usage:"
echo "  Navigate to any project directory and run:"
echo ""
echo "    cd ~/your-project"
echo "    claude-container"
echo ""
echo "  With a prompt:"
echo "    claude-container \"add unit tests for the auth package\""
echo ""
echo "  With kubectl access:"
echo "    claude-container --kubeconfig \"list pods in the default namespace\""
