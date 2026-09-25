return {
  {
    "j-hui/fidget.nvim",
    version = "*",
    event = "VeryLazy",
    main = "fidget",
    opts = {
      progress = {
        suppress_on_insert = true,
      },
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
}
