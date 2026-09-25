local detail_view = false

function _G.get_oil_winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local directory = require("oil").get_current_dir(bufnr)

  if directory then
    return vim.fn.fnamemodify(directory, ":~")
  end

  return vim.api.nvim_buf_get_name(bufnr)
end

return {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
	    "nvim-mini/mini.icons",
    },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
    },
opts = {
      default_file_explorer = true,
      columns = {
        "icon",
      },
      win_options = {
        winbar = "%!v:lua.get_oil_winbar()",
      },
      keymaps = {
        ["gd"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail_view = not detail_view

            if detail_view then
              require("oil").set_columns({
                "icon",
                "permissions",
                "size",
                "mtime",
              })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
        ["gp"] = "actions.preview",
        ["g."] = "actions.toggle_hidden",
	["q"] = "actions.close",
      },
      view_options = {
        show_hidden = true,
      },
},
}
