#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Dotfiles installer
# Supports: macOS (Homebrew), Arch Linux (yay)
# ============================================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log()   { echo -e "${GREEN}${BOLD}==>${NC} $*"; }
info()  { echo -e "${BLUE}  ->${NC} $*"; }
warn()  { echo -e "${YELLOW}  WARN:${NC} $*"; }
error() { echo -e "${RED}  ERROR:${NC} $*" >&2; exit 1; }

# ============================================================
# OS Detection
# ============================================================
OS=""

detect_os() {
  case "$(uname -s)" in
    Darwin)
      OS="macos"
      ;;
    Linux)
      if [ -f /etc/arch-release ]; then
        OS="arch"
      else
        error "Linux detected but not Arch. Only macOS and Arch Linux are supported."
      fi
      ;;
    *)
      error "Unsupported OS: $(uname -s)"
      ;;
  esac
  log "Detected OS: $OS"
}

# ============================================================
# Package Manager Setup
# ============================================================

ensure_brew() {
  if command -v brew &>/dev/null; then
    info "Homebrew already installed"
    return
  fi
  log "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for the rest of this script (Apple Silicon vs Intel)
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

ensure_yay() {
  if command -v yay &>/dev/null; then
    info "yay already installed"
    return
  fi
  log "Installing yay (AUR helper)..."
  sudo pacman -S --needed --noconfirm git base-devel
  local tmp
  tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmp/yay"
  (cd "$tmp/yay" && makepkg -si --noconfirm)
  rm -rf "$tmp"
  info "yay installed"
}

# ============================================================
# Install Helpers
# ============================================================

is_installed() { command -v "$1" &>/dev/null; }

pkg_install() {
  local pkg="$1"
  case "$OS" in
    macos) brew install "$pkg" ;;
    arch)  yay -S --noconfirm "$pkg" ;;
  esac
}

cask_install() {
  # $1 = macOS cask name, $2 = Arch AUR package name
  local mac_pkg="$1"
  local arch_pkg="${2:-$1}"
  case "$OS" in
    macos) brew install --cask "$mac_pkg" ;;
    arch)  yay -S --noconfirm "$arch_pkg" ;;
  esac
}

cask_installed_mac() {
  brew list --cask "$1" &>/dev/null
}

pkg_outdated_brew() {
  brew outdated --quiet 2>/dev/null | grep -q "^${1}$"
}

# ============================================================
# Tool Checks
# ============================================================

check_ghostty() {
  log "Checking Ghostty..."
  if [ "$OS" = "macos" ]; then
    if cask_installed_mac ghostty; then
      info "Ghostty already installed"
    else
      log "Installing Ghostty..."
      brew install --cask ghostty
    fi
  elif [ "$OS" = "arch" ]; then
    if is_installed ghostty; then
      info "Ghostty already installed"
    else
      log "Installing Ghostty..."
      yay -S --noconfirm ghostty
    fi
  fi
}

check_neovim() {
  log "Checking Neovim..."
  if [ "$OS" = "macos" ]; then
    if ! is_installed nvim; then
      log "Installing Neovim (latest stable)..."
      brew install neovim
    elif pkg_outdated_brew neovim; then
      log "Upgrading Neovim to latest stable..."
      brew upgrade neovim
    else
      info "Neovim is up to date: $(nvim --version | head -1)"
    fi
  elif [ "$OS" = "arch" ]; then
    if ! is_installed nvim; then
      log "Installing Neovim (latest stable)..."
      yay -S --noconfirm neovim
    else
      info "Neovim installed: $(nvim --version | head -1)"
      log "Checking for Neovim updates..."
      yay -Syu --noconfirm neovim
    fi
  fi
}

check_starship() {
  log "Checking Starship..."
  if is_installed starship; then
    info "Starship already installed: $(starship --version | head -1)"
  else
    log "Installing Starship..."
    pkg_install starship
  fi
}

check_fd() {
  log "Checking fd..."
  if is_installed fd; then
    info "fd already installed"
  else
    log "Installing fd..."
    pkg_install fd
  fi
}

check_ripgrep() {
  log "Checking ripgrep..."
  if is_installed rg; then
    info "ripgrep already installed"
  else
    log "Installing ripgrep..."
    pkg_install ripgrep
  fi
}

check_node() {
  log "Checking Node.js..."
  if is_installed node; then
    info "Node.js already installed: $(node --version)"
  else
    log "Installing Node.js..."
    pkg_install node
  fi
}

check_font() {
  log "Checking BigBlueTerm437 Nerd Font..."
  if [ "$OS" = "macos" ]; then
    if cask_installed_mac font-bigblueterm437-nerd-font; then
      info "BigBlueTerm437 Nerd Font already installed"
    else
      log "Installing BigBlueTerm437 Nerd Font..."
      brew install --cask font-bigblueterm437-nerd-font
    fi
  elif [ "$OS" = "arch" ]; then
    if fc-list 2>/dev/null | grep -qi "BigBlueTerm"; then
      info "BigBlueTerm437 Nerd Font already installed"
    else
      log "Installing BigBlueTerm437 Nerd Font..."
      if ! yay -S --noconfirm ttf-bigblueterm437-nerd 2>/dev/null; then
        warn "Could not find AUR package for BigBlueTerm437 Nerd Font."
        warn "Install manually from: https://www.nerdfonts.com/font-downloads"
      fi
    fi
  fi
}

# ============================================================
# Symlinking
# ============================================================

backup_if_exists() {
  local target="$1"
  # Only back up real files/dirs — not existing symlinks
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.bak.${TIMESTAMP}"
    warn "Existing path found at $target"
    warn "Backing up to $backup"
    mv "$target" "$backup"
  fi
}

link_config() {
  local src="$1"
  local dst="$2"

  # Already pointing to the right place — skip
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    info "Already linked: $dst"
    return
  fi

  backup_if_exists "$dst"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  info "Linked: $dst -> $src"
}

setup_symlinks() {
  log "Setting up symlinks..."
  link_config "$REPO_DIR/nvim"          "$HOME/.config/nvim"
  link_config "$REPO_DIR/ghostty"       "$HOME/.config/ghostty"
  link_config "$REPO_DIR/starship.toml" "$HOME/.config/starship.toml"
  link_config "$REPO_DIR/zsh/.zshrc"   "$HOME/.zshrc"
}

# ============================================================
# Main
# ============================================================

main() {
  echo ""
  echo -e "${BOLD}Dotfiles Installer${NC}"
  echo "========================================"
  echo ""

  detect_os

  case "$OS" in
    macos)
      ensure_brew
      log "Updating Homebrew..."
      brew update
      ;;
    arch)
      ensure_yay
      ;;
  esac

  check_ghostty
  check_neovim
  check_starship
  check_fd
  check_ripgrep
  check_node
  check_font
  setup_symlinks

  echo ""
  log "Done! Restart your terminal to apply all changes."
}

main "$@"
