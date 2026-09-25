return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    main = "treesitter-context",
    opts = {
      max_lines = 3,
      min_window_height = 20,
      multiline_threshold = 1,
      mode = "cursor",
    },
  },
}
