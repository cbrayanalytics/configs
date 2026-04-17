-- NOTE: harpoon uses <leader>m (mark) prefix to avoid collision with
-- gitsigns <leader>h (hunk) namespace. Do NOT enable LazyVim's
-- harpoon2 extra — it would duplicate these bindings.
return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = function()
      local harpoon = require("harpoon")
      return {
        { "<leader>ma", function() harpoon:list():add() end,                         desc = "Harpoon: add file" },
        { "<leader>mm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon: menu" },
        { "<C-e>",      function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon: menu" },
        { "<leader>1",  function() harpoon:list():select(1) end,                     desc = "Harpoon: file 1" },
        { "<leader>2",  function() harpoon:list():select(2) end,                     desc = "Harpoon: file 2" },
        { "<leader>3",  function() harpoon:list():select(3) end,                     desc = "Harpoon: file 3" },
        { "<leader>4",  function() harpoon:list():select(4) end,                     desc = "Harpoon: file 4" },
        { "<leader>mp", function() harpoon:list():prev() end,                        desc = "Harpoon: prev" },
        { "<leader>mn", function() harpoon:list():next() end,                        desc = "Harpoon: next" },
      }
    end,
    opts = {
      settings = {
        save_on_toggle = true,
      },
    },
    config = function(_, opts)
      require("harpoon"):setup(opts)
    end,
  },
}
