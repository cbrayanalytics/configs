local float_terminal
local horizontal_terminal

local function close_if_open(terminal)
  if terminal and terminal:is_open() then
    terminal:close()
  end
end

return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      {
        "<leader>tf",
        function()
          close_if_open(horizontal_terminal)
          float_terminal:toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle floating terminal",
      },
      {
        "<leader>th",
        function()
          close_if_open(float_terminal)
          horizontal_terminal:toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle horizontal terminal",
      },
    },
    opts = {
      size = 15,
      start_in_insert = true,
      persist_mode = true,
      close_on_exit = true,
      float_opts = {
        border = "rounded",
      },
      on_open = function(terminal)
        vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], {
          buffer = terminal.bufnr,
          desc = "Exit terminal mode",
        })
      end,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      float_terminal = Terminal:new({
        direction = "float",
        hidden = true,
        display_name = "Floating terminal",
      })

      horizontal_terminal = Terminal:new({
        direction = "horizontal",
        hidden = true,
        display_name = "Horizontal terminal",
      })
    end,
  },
}
