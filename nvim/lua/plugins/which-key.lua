return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-mini/mini.icons",
		},
		opts = {
			preset = "modern",
			icons = {
				mappings = true,
				colors = true,
			},
			win = {
				border = "rounded",
				padding = { 1, 2 },
				title = true,
				title_pos = "center",
			},
			layout = {
				width = {
					min = 24,
					max = 50,
				},
				spacing = 4,
			},
			spec = {
				{
					"<leader>f",
					group = "Find",
					icon = { icon = "", color = "cyan" },
				},
				{
					"<leader>c",
					group = "Code",
					icon = { icon = "", color = "blue" },
				},
				{
					"<leader>m",
					group = "Markdown",
					icon = { icon = "", color = "azure" },
				},
				{
					"<leader>t",
					group = "Terminal",
					icon = { icon = "", color = "green" },
				},
				{
					"<leader>x",
					group = "Diagnostics",
					icon = { icon = "", color = "orange" },
				},
				{
					"<leader>s",
					group = "Sessions",
					icon = "󰆓",
				},
				{
					"<leader><Tab>",
					group = "Tabs",
					icon = "󰓩",
				},
				{
					"<leader>r",
					group = "Run tests",
					icon = "󰙨",
				},
			},
		},
	},
}
