return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "neovim-treesitter/treesitter-parser-registry",
    },
    lazy = false,
    build = ":TSUpdate",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sh", "go", "gomod", "gowork", "markdown", "python", "lua", "vim", "vimdoc" },
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}
