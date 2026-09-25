# Neovim configuration

This repository contains a focused Neovim configuration built around native
Neovim features and a small set of plugins managed by lazy.nvim. It provides
language support, completion, formatting, linting, testing, navigation, Git
signs, terminals, sessions, diagnostics, and visual polish without turning the
configuration into a prebuilt distribution.

The configuration is currently tested with Neovim 0.12.5 on macOS. The leader
key is `Space`.

## Highlights

- Catppuccin Mocha theme with a global lualine statusline.
- Native LSP configuration managed through Mason.
- Blink completion with LSP, path, snippet, and buffer sources.
- Treesitter highlighting, sticky context, rainbow delimiters, and indent
  guides.
- Formatting on save through conform.nvim.
- Shell and Markdown linting through nvim-lint.
- Telescope search, Oil file browsing, Trouble diagnostics, and ToggleTerm.
- Neotest support for Go, Python with pytest, and Bash with bashunit.
- Native project sessions keyed by the current working directory.
- Which-key groups and Nerd Font icons for discoverability.

## Requirements

- Neovim 0.12 or newer is recommended.
- Git.
- A Nerd Font configured in the terminal.
- `make` and a C compiler for Telescope's native FZF extension.
- `ripgrep` for Telescope live grep.
- Language runtimes and test tools for the languages being used.

## Installation

Clone the repository to a convenient location:

```bash
git clone https://github.com/cbrayanalytics/configs.git ~/configs
```

If `~/.config/nvim` already exists, move it to a backup location first. Then
link this configuration into Neovim's standard configuration path:

```bash
ln -s ~/configs/nvim ~/.config/nvim
```

Start Neovim:

```bash
nvim
```

lazy.nvim bootstraps itself on the first launch and installs the configured
plugins. Mason installs the configured language servers.

## Repository layout

```text
.
├── README.md
└── nvim
    ├── init.lua
    ├── lazy-lock.json
    ├── lua
    │   ├── config
    │   │   ├── autocmds.lua
    │   │   ├── diagnostics.lua
    │   │   ├── keymaps.lua
    │   │   ├── lazy.lua
    │   │   ├── options.lua
    │   │   └── sessions.lua
    │   └── plugins
    │       └── *.lua
    └── plugin
        └── filetypes.lua
```

`lua/config/` contains core Neovim behavior. `lua/plugins/` contains one focused
lazy.nvim specification per feature. `plugin/filetypes.lua` registers the Bash
Treesitter parser alias required by Neotest's child process.

## Language tooling

| Language | LSP | Formatting | Linting or analysis | Tests |
| --- | --- | --- | --- | --- |
| Bash | bash-language-server | shfmt | ShellCheck | bashunit |
| Go | gopls | goimports, gofumpt | gopls staticcheck | `go test` |
| Python | Pyright, Ruff | Ruff | Pyright, Ruff | pytest |
| Markdown | Marksman | markdownlint-cli2 | markdownlint-cli2 | — |
| Lua | — | StyLua | — | — |

Open `:Mason` and ensure the following tools are installed:

- `bash-language-server`
- `gofumpt`
- `goimports`
- `gopls`
- `markdownlint-cli2`
- `marksman`
- `pyright`
- `ruff`
- `shellcheck`
- `shfmt`
- `stylua`

Install bashunit globally on macOS with:

```bash
brew install bashunit
```

For Python projects, create a project virtual environment and install pytest in
that environment:

```bash
python3 -m venv .venv
```

```bash
.venv/bin/python -m pip install pytest
```

## Keybindings

`<leader>` means `Space`.

### General and windows

| Key | Action |
| --- | --- |
| `jj` | Leave insert mode |
| `<leader><leader>` | Clear search highlighting |
| `<leader>w` | Write the current file |
| `<leader>q` | Close the current window |
| `Ctrl-h/j/k/l` | Move between windows |
| `Space`, then vertical bar | Create a vertical split |
| `<leader>-` | Create a horizontal split |
| `<leader><Tab><Tab>` | Create a tab |
| `<leader><Tab>q` | Close the current tab |
| `<leader><Tab>]` | Go to the next tab |
| `<leader><Tab>[` | Go to the previous tab |

### Finding and files

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Search project text |
| `<leader>fb` | Find open buffers |
| `<leader>fh` | Search help tags |
| `-` | Open Oil at the parent directory |

Inside Oil, `q` closes the browser, `gd` toggles details, `gp` toggles the
preview, and `g.` toggles hidden files.

### Code and diagnostics

| Key | Action |
| --- | --- |
| `<leader>cd` | Show diagnostics for the current line |
| `<leader>ca` | Show code actions |
| `<leader>cr` | Rename the current symbol |
| `<leader>cR` | Find references with Telescope |
| `<leader>cf` | Format the file or visual selection |
| `<leader>xx` | Toggle workspace diagnostics |
| `<leader>xX` | Toggle diagnostics for the current buffer |

Neovim's standard LSP mappings remain available, including `K` for hover
documentation. nvim-surround uses its standard `ys`, `ds`, and `cs` operations.

### Terminals, sessions, and Markdown

| Key | Action |
| --- | --- |
| `<leader>tf` | Toggle the floating terminal |
| `<leader>th` | Toggle the horizontal terminal |
| `Esc Esc` | Leave terminal input mode |
| `<leader>ss` | Save the current project session |
| `<leader>sr` | Restore the current project session |
| `<leader>mr` | Toggle rendered Markdown |

Sessions are stored under Neovim's state directory and are keyed by a hash of
the current working directory. Restoration is refused while a loaded buffer has
unsaved changes.

### Tests

| Key | Action |
| --- | --- |
| `<leader>rr` | Run the nearest test |
| `<leader>rf` | Run the current test file |
| `<leader>rs` | Toggle the test summary |
| `<leader>ro` | Show test output |
| `<leader>rS` | Stop a running test |

## Useful commands

| Command | Purpose |
| --- | --- |
| `:Lazy` | Inspect, install, and update plugins |
| `:Mason` | Inspect and install development tools |
| `:ConformInfo` | Show formatters available for the current buffer |
| `:LspInfo` | Show language servers attached to the current buffer |
| `:checkhealth` | Run Neovim and plugin health checks |

Run a complete headless health check from the terminal with:

```bash
nvim --headless "+checkhealth" "+qa"
```
