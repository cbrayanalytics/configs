return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc",
        "python", "go", "gomod", "gosum",
        "javascript", "typescript", "json",
        "bash", "markdown", "markdown_inline",
        "yaml", "toml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
