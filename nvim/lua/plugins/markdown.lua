return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>mr",
				"<cmd>RenderMarkdown toggle<CR>",
				desc = "Toggle rendered Markdown",
			},
		},
		opts = {
			heading = {
				sign = true,
				width = "block",
				left_pad = 1,
				right_pad = 1,
				border = false,
			},
			code = {
				sign = true,
				width = "block",
				left_pad = 1,
				right_pad = 1,
				border = "thin",
			},
			pipe_table = {
				preset = "heavy",
				cell = "trimmed",
				wrap = false,
				border_virtual = true,
			},
			quote = {
				repeat_linebreak = false,
			},
			win_options = {
				wrap = {
					default = vim.o.wrap,
					rendered = false,
				},
				linebreak = {
					default = vim.o.linebreak,
					rendered = true,
				},
				breakindent = {
					default = vim.o.breakindent,
					rendered = true,
				},
				showbreak = {
					default = vim.o.showbreak,
					rendered = "  ",
				},
				breakindentopt = {
					default = vim.o.breakindentopt,
					rendered = "",
				},
			},
			completions = {
				lsp = {
					enabled = true,
				},
			},
		},
	},
}
