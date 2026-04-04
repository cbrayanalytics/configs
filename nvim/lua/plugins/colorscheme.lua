return {
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000, -- load before other plugins
    opts = {
      filter = "classic",
      terminal_colors = true,
      devicons = true,
    },
    config = function(_, opts)
      require("monokai-pro").setup(opts)
      vim.cmd.colorscheme("monokai-pro-classic")
    end,
  },
}
