# ==================================================
# Exports
# ==================================================
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL="vim"
else
  export EDITOR='nvim'
  export VISUAL="nvim"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Add `gopls` to path
export PATH="$HOME/go/bin:$PATH"

# Use bat for syntax-highlighted man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# fzf: use fd for file finding + nicer UI defaults
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# ==================================================
# Shell Integration
# ==================================================
if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
  source "${GHOSTTY_RESOURCES_DIR}/shell-integration/zsh/ghostty-integration"
fi

# ==================================================
# Theme
# ==================================================
# Leave zsh theme blank for "Starship"
ZSH_THEME=""

# Set a list of themes for random pickup
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# ==================================================
# Update
# ==================================================
# For automatic updates (disabled, auto, reminder)
zstyle ':omz:update' mode auto

# Frequency of updates (days)
zstyle ':omz:update' frequency 6

# ==================================================
# Formatting
# ==================================================
# Disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Disable marking untracked files under VCS as dirty
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Move completion dump file out of `$HOME` to reduce dotfile clutter
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

# ==================================================
# History
# ==================================================
# File history will be stored in
HISTFILE=~/.zsh_history

# Amount of history to be stored
HISTSIZE=1000000

# Amount of history lines to be saved
SAVEHIST=1000000

# Timestamp shown in the history command output:
#    - ("mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd")
HIST_STAMPS="yyyy-mm-dd"

# History options via `setopt`
setopt EXTENDED_HISTORY SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS

# ==================================================
# Plugins
# ==================================================
# Plugin locations:
#    - Standard plugins: $ZSH/plugins/
#    - Custom plugins: $ZSH_CUSTOM/plugins/

# Plugins to load in (list-format) 
##WARNING: Too many plugins slow things down!
plugins=(
	# Core plugins
	git                      # Git aliases (e.g. gst, gco, gp)
	vi-mode                  # Enables vi keybindings in shell
	fzf                      # Uses fuzzy-finder for search history
	zsh-autosuggestions      # Fish-style inline suggestions from cmd history

	# Navigation & History plugins
	history-substring-search  # Type cmd & use arrows to cycle matching history
	fancy-ctrl-z       # Press `ctrl+z` to background; again to foreground
	sudo               # Hit `esc-esc` to prepend `sudo`
	extract            # Single extract command hanles all extensions

	# Quality of life
	colored-man-pages
	dotenv             # Auto-loads `.env` files in current dir
	aliases            # run `acs` to view active alises
	safe-paste         # Prevents text from auto-executing
	command-not-found  # Suggests package to install when not found
	copypath           # Copies current dir to clipboard

	zsh-syntax-highlighting  # Colors cmd as typed (must be last)
)

# ==================================================
# Source-File
# ==================================================
fpath+=~/.zfunc
source $ZSH/oh-my-zsh.sh

# ==================================================
# Starship
# ==================================================
eval "$(starship init zsh)"

# ==================================================
# zoxide
# ==================================================
eval "$(zoxide init zsh --cmd cd)"

# ==================================================
# Aliases
# ==================================================
# Set personal aliases, overriding aliases above
# For a full list of active aliases, run `alias`
#
# Also, can place aliases in $ZSH_CUSTOM folder, with .zsh extension
#   - $ZSH_CUSTOM/aliases.zsh
#   - $ZSH_CUSTOM/macos.zsh

# ZSH aliases for quick-config
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim $ZSH_CUSTOM"
alias nvimconfig="nvim ~/.config/nvim/lua/"
alias nvimplugins="nvim ~/.config/nvim/lua/plugins"
alias ghosttyconfig="nvim ~/.config/ghostty/config"
alias starshipconfig="nvim ~/.config/starship.toml"

# Modern command replacements
alias ls="eza --icons=always --color=always"     # modern ls w/icons
alias ll="eza -l --icons=always --color=always"  # long format
alias la="eza -la --icons=always --color=always" # long format + hidden files
alias lt="eza --tree --icons=always --color=always" # tree view
alias cat="bat"   # Syntax-highlighted `cat`
alias rgrep="rg"  # ripgrep (avoids shadowing system grep)
alias find="fd"   # fast find
alias top="btop"  # visual system monitor

# Neovim related aliases
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# ==================================================
# Functions
# ==================================================
# Create a directory and cd into it
mkcd() { mkdir -p "$@" && cd "$@" }

