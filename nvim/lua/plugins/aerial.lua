return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>a", "<cmd>AerialToggle!<cr>", desc = "Toggle aerial outline" },
    },
    opts = {
      attach_mode = "cursor",
      backends = { "lsp", "treesitter", "markdown", "man" },
      show_guides = true,
      layout = {
        max_width = { 40, 0.2 },
        width = nil,
        min_width = 20,
        win_opts = {},
        placement = "window",
        resize_to_content = true,
        preserve_equality = false,
      },
    },
  },
}
