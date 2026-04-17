return {
  -- Extended text objects: cia, daa, vif, etc.
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 200,
        custom_textobjects = {
          -- Function outer/inner via treesitter
          f = ai.gen_spec.treesitter({
            a = "@function.outer",
            i = "@function.inner",
          }),
          -- Class outer/inner via treesitter
          c = ai.gen_spec.treesitter({
            a = "@class.outer",
            i = "@class.inner",
          }),
          -- Conditional outer/inner via treesitter
          o = ai.gen_spec.treesitter({
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          }),
        },
      }
    end,
  },
  -- Move lines and selections with Alt+hjkl
  {
    "echasnovski/mini.move",
    version = false,
    event = "VeryLazy",
    opts = {
      mappings = {
        -- Move visual selection
        left  = "<M-h>",
        right = "<M-l>",
        down  = "<M-j>",
        up    = "<M-k>",
        -- Move current line in Normal mode
        line_left  = "<M-h>",
        line_right = "<M-l>",
        line_down  = "<M-j>",
        line_up    = "<M-k>",
      },
    },
  },
}
