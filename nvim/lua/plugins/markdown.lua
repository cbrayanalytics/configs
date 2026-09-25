return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle rendered Markdown" },
    },
    opts = {
      completions = {
        lsp = {
          enabled = true,
        },
      },
    },
  },
}
