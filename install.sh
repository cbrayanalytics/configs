#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# ============================================================
# Bootstrap helpers — plain ANSI, used before gum is available
# ============================================================
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

blog()  { echo -e "${GREEN}${BOLD}==>${NC} $*"; }
bwarn() { echo -e "${YELLOW}  WARN:${NC} $*"; }
berror(){ echo -e "${RED}  ERROR:${NC} $*" >&2; exit 1; }

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
        berror "Linux detected but not Arch. Only macOS and Arch Linux are supported."
      fi
      ;;
    *) berror "Unsupported OS: $uname" ;;
  esac
  blog "Detected OS: $OS"
}

# ============================================================
# Package Manager Bootstrap
# ============================================================

ensure_brew() {
  if command -v brew &>/dev/null; then return; fi
  blog "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

ensure_yay() {
  if command -v yay &>/dev/null; then return; fi
  blog "Installing yay (AUR helper)..."
  sudo pacman -S --needed --noconfirm git base-devel
  local tmp
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  git clone https://aur.archlinux.org/yay.git "$tmp/yay"
  (cd "$tmp/yay" && makepkg -si --noconfirm)
  rm -rf "$tmp"
  trap - EXIT
}

ensure_gum() {
  if command -v gum &>/dev/null; then return; fi
  blog "Installing gum..."
  case "$OS" in
    macos) brew install gum ;;
    arch)  yay -S --noconfirm gum ;;
  esac
}

# ============================================================
# Gum helpers — available after ensure_gum
# ============================================================

is_installed()      { command -v "$1" &>/dev/null; }
cask_installed_mac(){ brew list --cask "$1" &>/dev/null; }
pkg_outdated_brew() { brew outdated --quiet 2>/dev/null | grep -q "^${1}$"; }

ok()    { gum style --foreground 2 "  ✓ $*"; }
skip()  { gum style --foreground 8 "  · $*"; }
gwarn() { gum style --foreground 3 "  ⚠ $*"; }

section() { echo ""; gum style --foreground 99 --bold "  $*"; }

spin_install() {
  local title="$1"; shift
  gum spin --spinner dot --title "    $title" -- "$@"
}

ensure_pkg() {
  local display="$1" pkg="$2" cmd="${3:-$2}"
  if is_installed "$cmd"; then
    skip "$display"
    return
  fi
  case "$OS" in
    macos) spin_install "Installing $display..." brew install "$pkg" ;;
    arch)  spin_install "Installing $display..." yay -S --noconfirm "$pkg" ;;
  esac
  ok "$display"
}

ensure_cask() {
  local display="$1" mac_cask="$2" arch_pkg="$3" arch_cmd="${4:-$3}"
  if [ "$OS" = "macos" ]; then
    if cask_installed_mac "$mac_cask"; then
      skip "$display"
    else
      spin_install "Installing $display..." brew install --cask "$mac_cask"
      ok "$display"
    fi
  elif [ "$OS" = "arch" ]; then
    if is_installed "$arch_cmd"; then
      skip "$display"
    else
      spin_install "Installing $display..." yay -S --noconfirm "$arch_pkg"
      ok "$display"
    fi
  fi
}

# ============================================================
# Tool Checks
# ============================================================

check_ohmyzsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    spin_install "Installing Oh My Zsh..." \
      bash -c 'RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
    ok "Oh My Zsh"
  else
    skip "Oh My Zsh"
  fi

  local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

  if [ ! -d "$custom/zsh-autosuggestions" ]; then
    spin_install "Installing zsh-autosuggestions..." \
      git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$custom/zsh-autosuggestions"
    ok "zsh-autosuggestions"
  else
    skip "zsh-autosuggestions"
  fi

  if [ ! -d "$custom/zsh-syntax-highlighting" ]; then
    spin_install "Installing zsh-syntax-highlighting..." \
      git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$custom/zsh-syntax-highlighting"
    ok "zsh-syntax-highlighting"
  else
    skip "zsh-syntax-highlighting"
  fi
}

check_neovim() {
  if [ "$OS" = "macos" ]; then
    if ! is_installed nvim; then
      spin_install "Installing Neovim..." brew install neovim
      ok "Neovim"
    elif pkg_outdated_brew neovim; then
      spin_install "Upgrading Neovim..." brew upgrade neovim
      ok "Neovim (upgraded)"
    else
      skip "Neovim (up to date)"
    fi
  elif [ "$OS" = "arch" ]; then
    if ! is_installed nvim; then
      spin_install "Installing Neovim..." yay -S --noconfirm neovim
      ok "Neovim"
    elif yay -Qu neovim &>/dev/null; then
      spin_install "Upgrading Neovim..." yay -S --noconfirm neovim
      ok "Neovim (upgraded)"
    else
      skip "Neovim (up to date)"
    fi
  fi
}

check_font() {
  if [ "$OS" = "macos" ]; then
    if cask_installed_mac font-bigblue-terminal-nerd-font; then
      skip "BigBlueTerm437 Nerd Font"
    else
      spin_install "Installing BigBlueTerm437 Nerd Font..." brew install --cask font-bigblue-terminal-nerd-font
      ok "BigBlueTerm437 Nerd Font"
    fi
  elif [ "$OS" = "arch" ]; then
    if fc-list 2>/dev/null | grep -qi "BigBlueTerm"; then
      skip "BigBlueTerm437 Nerd Font"
    else
      if spin_install "Installing BigBlueTerm437 Nerd Font..." yay -S --noconfirm ttf-bigblueterm437-nerd 2>/dev/null; then
        ok "BigBlueTerm437 Nerd Font"
      else
        gwarn "BigBlueTerm437 Nerd Font not found in AUR — install manually: https://www.nerdfonts.com/font-downloads"
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
    gwarn "Backing up $(basename "$target") → $backup"
    mv "$target" "$backup"
  fi
}

link_config() {
  local src="$1" dst="$2" label
  label="$(basename "$dst")"

  if [ "$src" = "$dst" ]; then
    skip "$label (repo is at target location)"
    return
  fi

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    skip "$label"
    return
  fi

  if [ -L "$dst" ] && [ ! -e "$dst" ]; then
    rm "$dst"
  fi

  backup_if_exists "$dst"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  ok "$label"
}

# ============================================================
# Main
# ============================================================

main() {
  # ---- Phase 1: Bootstrap (plain output) ----
  detect_os

  case "$OS" in
    macos)
      ensure_brew
      blog "Updating Homebrew..."
      brew update -q
      ;;
    arch)
      ensure_yay
      ;;
  esac

  ensure_gum

  # ---- Phase 2: Gum-powered ----
  clear

  gum style \
    --foreground 212 --border-foreground 212 --border rounded \
    --align center --width 50 --margin "1 2" --padding "1 2" \
    "$(gum style --bold --foreground 212 'Dotfiles Installer')"

  section "Shell"
  check_ohmyzsh
  ensure_pkg "Starship" "starship"
  ensure_pkg "zoxide"   "zoxide"
  ensure_pkg "fzf"      "fzf"

  section "Terminal"
  ensure_cask "Ghostty" "ghostty" "ghostty" "ghostty"
  check_font

  section "Editor"
  check_neovim

  section "Neovim dependencies"
  ensure_pkg "fd"      "fd"
  ensure_pkg "ripgrep" "ripgrep" "rg"
  ensure_pkg "Node.js" "node"
  ensure_pkg "Python"  "python3"

  section "CLI tools"
  ensure_pkg "eza"  "eza"
  ensure_pkg "bat"  "bat"
  ensure_pkg "btop" "btop"

  section "Symlinks"
  link_config "$REPO_DIR/nvim"          "$HOME/.config/nvim"
  link_config "$REPO_DIR/ghostty"       "$HOME/.config/ghostty"
  link_config "$REPO_DIR/starship.toml" "$HOME/.config/starship.toml"
  link_config "$REPO_DIR/zsh/.zshrc"   "$HOME/.zshrc"

  echo ""
  gum style --foreground 2 --bold "  All done!"
  echo ""

  choice=$(gum choose \
    "Reload shell (exec zsh)" \
    "Reload Ghostty config" \
    "Do nothing")

  case "$choice" in
    "Reload shell (exec zsh)")
      exec zsh
      ;;
    "Reload Ghostty config")
      if [ "$OS" = "macos" ]; then
        osascript -e 'tell application "System Events" to tell process "Ghostty" to keystroke "," using {shift down, command down}'
        ok "Ghostty config reloaded"
      else
        gwarn "Ghostty config reload via script is only supported on macOS. Please restart manually."
      fi
      ;;
    *)
      gum style --foreground 8 "  Run 'exec zsh' or reload Ghostty when ready."
      ;;
  esac
}

main "$@"
