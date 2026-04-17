return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      -- Persist these options with the session
      options = { "buffers", "curdir", "tabpages", "winsize", "help" },
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Session: restore (cwd)" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Session: restore last" },
      { "<leader>qw", function() require("persistence").save() end,                desc = "Session: save now" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Session: don't save on exit" },
    },
  },
}
