return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-mini/mini.icons",
		},
		keys = {
			{
				"<leader>e",
				"<cmd>Neotree filesystem toggle float<cr>",
				desc = "Toggle file explorer",
			},
			{
				"<leader>E",
				"<cmd>Neotree filesystem reveal float<cr>",
				desc = "Reveal current file",
			},
		},
		opts = {
			close_if_last_window = true,
			enable_diagnostics = true,
			enable_git_status = true,
			popup_border_style = "rounded",
			event_handlers = {
				{
					event = "file_opened",
					handler = function()
						require("neo-tree.command").execute({ action = "close" })
					end,
				},
			},
			window = {
				position = "float",
				popup = {
					size = {
						height = "75%",
						width = "70%",
					},
				},
				mappings = {
					["<esc>"] = "close_window",
					["q"] = "close_window",
					["P"] = {
						"toggle_preview",
						config = {
							use_float = true,
						},
					},
				},
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				filtered_items = {
					visible = true,
					never_show = {
						".DS_Store",
					},
				},
			},
		},
	},
}
