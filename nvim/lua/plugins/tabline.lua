local function current_filename(tabid)
	local winid = vim.api.nvim_tabpage_get_win(tabid)
	local bufnr = vim.api.nvim_win_get_buf(winid)
	local name = vim.api.nvim_buf_get_name(bufnr)

	if name == "" then
		return "[No Name]"
	end

	return vim.fn.fnamemodify(name, ":t")
end

return {
	{
		"nanozuki/tabby.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-mini/mini.icons",
		},
		keys = {
			{
				"<leader><Tab>j",
				"<cmd>Tabby jump_to_tab<cr>",
				desc = "Jump to tab",
			},
			{
				"<leader><Tab>r",
				function()
					vim.ui.input({ prompt = "Tab name: " }, function(name)
						if name and name ~= "" then
							vim.api.nvim_cmd({ cmd = "Tabby", args = { "rename_tab", name } }, {})
						end
					end)
				end,
				desc = "Rename tab",
			},
		},
		config = function()
			vim.opt.showtabline = 1

			local theme = {
				fill = "TabLineFill",
				current = "TabLineSel",
				inactive = "TabLine",
			}

			require("tabby").setup({
				line = function(line)
					return {
						line.tabs().foreach(function(tab)
							local highlight = tab.is_current() and theme.current or theme.inactive

							return {
								tab.is_current() and " 󰓩 " or " 󰓪 ",
								tab.number(),
								" ",
								tab.name(),
								tab.close_btn("  "),
								hl = highlight,
								margin = " ",
							}
						end),
						hl = theme.fill,
					}
				end,
				option = {
					tab_name = {
						name_fallback = current_filename,
					},
				},
			})
		end,
	},
}
