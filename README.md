# claude-container

Run [Claude Code](https://claude.ai/claude-code) inside Docker with a full developer toolset — no local installation required beyond Docker itself.

The container runs as your host user (same UID/GID), mounts your current project directory, and forwards your credentials so Claude can operate exactly as it would natively.

## What's included

| Tool | Purpose |
|------|---------|
| `claude` | Claude Code CLI |
| `git` | Version control |
| `gh` | GitHub CLI |
| `docker` CLI | Interact with the host Docker daemon |
| `kubectl` | Kubernetes CLI (latest stable) |
| `vault` | HashiCorp Vault CLI |
| `go` / `gofmt` | Go toolchain (latest stable) |
| `python3` / `pip` / `venv` | Python runtime |
| `vim` | Text editor |
| `ping`, `nslookup`, `dig` | Network diagnostics |
| `netstat`, `ip`, `ss` | Network tools |
| `nc`, `traceroute`, `tcpdump` | Advanced networking |
| `jq` | JSON processing |
| `wget`, `curl` | HTTP clients |
| `htop`, `lsof`, `less` | System utilities |
| `ssh`, `scp` | SSH client |

## Requirements

- Docker (with `buildx` for building multi-platform images)
- `ANTHROPIC_API_KEY` set in your environment

## Install

```bash
git clone https://github.com/eliasmeireles/claude-container.git
cd claude-container
bash install.sh
```

This copies `bin/claude-container` to `~/.local/bin/` and pulls the latest image from GHCR.

Make sure `~/.local/bin` is in your `PATH`:

```bash
export PATH="${HOME}/.local/bin:${PATH}"
```

## Usage

Navigate to any project directory and run:

```bash
cd ~/your-project
claude-container
```

The container mounts the current directory as `/workspace` and starts Claude Code interactively.

### With a prompt (non-interactive)

```bash
claude-container "add unit tests for the auth package"
```

### With kubectl access

```bash
claude-container --kubeconfig "list pods in the default namespace"
```

### With extra volumes

```bash
claude-container "refactor the handler" /other/path:/mnt/extra
```

## Environment variables forwarded automatically

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_API_KEY` | Required — Claude API key |
| `GITHUB_PERSONAL_ACCESS_TOKEN` | GitHub token for MCP/gh operations |
| `VAULT_ADDR` | HashiCorp Vault server address |
| `VAULT_NAMESPACE` | Vault namespace (HCP/Enterprise) |
| `VAULT_TOKEN` | Vault token (falls back to `~/.vault-token`) |

## Credentials mounted automatically

| File/Dir | Description |
|----------|-------------|
| `~/.claude` / `~/.claude.json` | Claude Code config and session |
| `~/.ssh` | SSH keys (read-only) |
| `~/.gitconfig` | Git identity |
| `~/.config/gh` | GitHub CLI auth |
| `~/.gnupg` | GPG keys for signed commits |
| `~/.kube` | Kubeconfig (when `--kubeconfig` is used) |
| `~/.vault-token` | Vault session token (if present) |
| `/var/run/docker.sock` | Host Docker socket (for MCP Docker tools) |

## Building the image

The image is published to GHCR for `linux/amd64` and `linux/arm64`.

To build and push it yourself:

```bash
make build
# or
bash build.sh
# or force a full rebuild
bash build.sh --no-cache
```

## License

MIT
