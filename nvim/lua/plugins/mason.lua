return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "gopls",
        "bashls",
      },
      automatic_enable = false, -- we handle vim.lsp.enable() manually
    },
  },
  -- Single source of truth for all tool installation (no registry validation)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",
        "black",
        "isort",
        "prettier",
        "shfmt",
        "shellcheck",
        "ruff",
        "golangci-lint",
      },
    },
  },
}
