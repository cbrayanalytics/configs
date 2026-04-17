return {
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
    },
    init = function()
      vim.g.undotree_WindowLayout = 2       -- tree left, diff below
      vim.g.undotree_ShortIndicators = 1    -- compact time display
      vim.g.undotree_SetFocusWhenToggle = 1 -- auto-focus tree on open
    end,
  },
}
