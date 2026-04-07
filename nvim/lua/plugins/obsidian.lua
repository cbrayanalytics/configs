return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>",       desc = "Obsidian: New note" },
      { "<leader>oo", "<cmd>ObsidianOpen<cr>",      desc = "Obsidian: Open in app" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>",    desc = "Obsidian: Search notes" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Obsidian: Backlinks" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>",     desc = "Obsidian: Links" },
      { "<leader>ot", "<cmd>ObsidianTemplate<cr>",  desc = "Obsidian: Insert template" },
      { "<leader>od", "<cmd>ObsidianToday<cr>",     desc = "Obsidian: Today's note" },
      { "<leader>or", "<cmd>ObsidianRename<cr>",    desc = "Obsidian: Rename note" },
    },
    opts = {
      workspaces = {
        { name = "notes", path = "~/Documents/notes" },
      },

      -- disable built-in UI — render-markdown.nvim handles rendering
      ui = { enable = false },

      -- open URLs with the system handler
      follow_url_func = function(url)
        local cmd = vim.fn.has("mac") == 1 and "open" or "xdg-open"
        vim.fn.jobstart({ cmd, url })
      end,

      -- prefer telescope for pickers
      picker = { name = "telescope" },

      completion = { nvim_cmp = false },

      attachments = { img_folder = "assets" },
    },
  },
}
