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
  {
    "rshkarin/mason-nvim-lint",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-lint" },
    opts = {
      ensure_installed = { "ruff", "golangcilint" },
      automatic_installation = true,
    },
  },
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
      },
    },
  },
}
