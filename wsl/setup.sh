#!/usr/bin/env bash
# Sets up WSL Ubuntu from this repo. Safe to re-run (idempotent).
# Usage: bash wsl/setup.sh
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> apt packages"
sudo apt update
sudo apt upgrade -y
sudo apt install -y \
  trash-cli tree bat htop unzip ffmpeg poppler-utils \
  neovim chafa nodejs npm build-essential \
  openjdk-25-jdk docker.io docker-compose-v2

echo "==> Rust (rustup)"
if ! command -v rustup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi
. "$HOME/.cargo/env"

echo "==> pnpm"
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
if ! command -v pnpm >/dev/null 2>&1; then
  curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

echo "==> Shell and Neovim config"
mkdir -p "$HOME/.config/nvim"
cp "$REPO/wsl/nvim/init.lua" "$HOME/.config/nvim/init.lua"
cp "$REPO/wsl/bashrc" "$HOME/.bashrc"

echo "==> Windows username (hardcoded into ~/.bashrc)"
WIN_USER="$(cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r\n' || true)"
if [ -z "$WIN_USER" ] || [ ! -d "/mnt/c/Users/$WIN_USER" ]; then
  read -rp "Could not detect Windows user. Enter it: " WIN_USER
fi
sed -i "s|__WIN_USER__|$WIN_USER|" "$HOME/.bashrc"

echo "==> Done. Open a new terminal or run: source ~/.bashrc"
