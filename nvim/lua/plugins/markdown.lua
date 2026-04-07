return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      heading = {
        enabled = true,
        -- progressively dimmer backgrounds per heading level
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
      },
      code = {
        enabled = true,
        style = "full",  -- full background behind code blocks
        border = "thin",
      },
      bullet     = { enabled = true },
      checkbox   = { enabled = true },
      table      = { enabled = true },
      quote      = { enabled = true },
      dash       = { enabled = true },
      link       = { enabled = true },
    },
  },
}
