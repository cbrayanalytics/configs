return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "gopls",
      },
      automatic_enable = false, -- we handle vim.lsp.enable() manually
    },
  },
  {
    "rshkarin/mason-nvim-lint",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-lint" },
    opts = {
      ensure_installed = { "ruff" },
      automatic_installation = { exclude = { "markdownlint-cli2" } },
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
        "markdownlint-cli2",
      },
    },
  },
}
