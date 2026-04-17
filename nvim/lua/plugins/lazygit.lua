return {
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      -- Open files from lazygit directly into the current Neovim session
      vim.g.lazygit_use_neovim_remote = 1
    end,
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>",                     mode = "n", desc = "LazyGit" },
      { "<leader>gc", "<cmd>LazyGitConfig<cr>",               mode = "n", desc = "LazyGit: config" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>",          mode = "n", desc = "LazyGit: current file log" },
      { "<leader>gl", "<cmd>LazyGitFilter<cr>",               mode = "n", desc = "LazyGit: filter commits" },
    },
  },
}
