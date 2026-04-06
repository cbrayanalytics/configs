#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Dotfiles installer
# Supports: macOS (Homebrew), Arch Linux (yay)
# ============================================================

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

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
  local uname
  uname="$(uname -s)"
  case "$uname" in
    Darwin) OS="macos" ;;
    Linux)
      if [ -f /etc/arch-release ]; then
        OS="arch"
      else
        error "Linux detected but not Arch. Only macOS and Arch Linux are supported."
      fi
      ;;
    *) error "Unsupported OS: $uname" ;;
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
  trap 'rm -rf "$tmp"' EXIT
  git clone https://aur.archlinux.org/yay.git "$tmp/yay"
  (cd "$tmp/yay" && makepkg -si --noconfirm)
  rm -rf "$tmp"
  trap - EXIT
  info "yay installed"
}

# ============================================================
# Install Helpers
# ============================================================

is_installed() { command -v "$1" &>/dev/null; }

pkg_install() {
  case "$OS" in
    macos) brew install "$1" ;;
    arch)  yay -S --noconfirm "$1" ;;
  esac
}

cask_installed_mac() { brew list --cask "$1" &>/dev/null; }

pkg_outdated_brew() { brew outdated --quiet 2>/dev/null | grep -q "^${1}$"; }

# Check and install a CLI package. Args: display_name pkg_name [cmd_to_check]
ensure_pkg() {
  local display="$1" pkg="$2" cmd="${3:-$2}"
  log "Checking $display..."
  if is_installed "$cmd"; then
    info "$display already installed"
    return
  fi
  log "Installing $display..."
  pkg_install "$pkg"
}

# Check and install a cask (GUI app). Args: display_name mac_cask arch_pkg [arch_cmd]
ensure_cask() {
  local display="$1" mac_cask="$2" arch_pkg="$3" arch_cmd="${4:-$3}"
  log "Checking $display..."
  if [ "$OS" = "macos" ]; then
    if cask_installed_mac "$mac_cask"; then
      info "$display already installed"
    else
      log "Installing $display..."
      brew install --cask "$mac_cask"
    fi
  elif [ "$OS" = "arch" ]; then
    if is_installed "$arch_cmd"; then
      info "$display already installed"
    else
      log "Installing $display..."
      yay -S --noconfirm "$arch_pkg"
    fi
  fi
}

# ============================================================
# Tool Checks (functions for tools with non-trivial logic)
# ============================================================

check_ohmyzsh() {
  log "Checking Oh My Zsh..."
  if [ -d "$HOME/.oh-my-zsh" ]; then
    info "Oh My Zsh already installed"
  else
    log "Installing Oh My Zsh..."
    # RUNZSH=no prevents switching shell mid-install; CHSH=no skips chsh prompt
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  if [ -d "$custom/zsh-autosuggestions" ]; then
    info "zsh-autosuggestions already installed"
  else
    log "Installing zsh-autosuggestions..."
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$custom/zsh-autosuggestions"
  fi

  if [ -d "$custom/zsh-syntax-highlighting" ]; then
    info "zsh-syntax-highlighting already installed"
  else
    log "Installing zsh-syntax-highlighting..."
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$custom/zsh-syntax-highlighting"
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
    elif yay -Qu neovim &>/dev/null; then
      log "Upgrading Neovim to latest stable..."
      yay -S --noconfirm neovim
    else
      info "Neovim is up to date: $(nvim --version | head -1)"
    fi
  fi
}

check_font() {
  log "Checking BigBlueTerm437 Nerd Font..."
  if [ "$OS" = "macos" ]; then
    if cask_installed_mac font-bigblue-terminal-nerd-font; then
      info "BigBlueTerm437 Nerd Font already installed"
    else
      log "Installing BigBlueTerm437 Nerd Font..."
      brew install --cask font-bigblue-terminal-nerd-font
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
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    local backup="${target}.bak.${TIMESTAMP}"
    warn "Backing up $target -> $backup"
    mv "$target" "$backup"
  fi
}

link_config() {
  local src="$1" dst="$2"

  # Repo is already at the target location — no symlink needed
  if [ "$src" = "$dst" ]; then
    info "In place: $dst"
    return
  fi

  # Already pointing to the right place — skip
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    info "Already linked: $dst"
    return
  fi

  # Remove broken symlink so backup_if_exists and ln -sf work correctly
  if [ -L "$dst" ] && [ ! -e "$dst" ]; then
    rm "$dst"
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

  # Shell
  check_ohmyzsh
  ensure_pkg "Starship"  "starship"
  ensure_pkg "zoxide"    "zoxide"
  ensure_pkg "fzf"       "fzf"

  # Terminal
  ensure_cask "Ghostty"  "ghostty"  "ghostty"  "ghostty"
  check_font

  # Editor
  check_neovim

  # Neovim runtime dependencies
  ensure_pkg "fd"        "fd"
  ensure_pkg "ripgrep"   "ripgrep"  "rg"
  ensure_pkg "Node.js"   "node"
  ensure_pkg "Python"    "python3"

  # Modern CLI tools (used in .zshrc aliases)
  ensure_pkg "eza"       "eza"
  ensure_pkg "bat"       "bat"
  ensure_pkg "btop"      "btop"

  setup_symlinks

  echo ""
  log "Done! Restart your terminal to apply all changes."
}

main "$@"
