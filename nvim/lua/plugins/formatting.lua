return {
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format file or selection",
			},
		},
		opts = {
			formatters_by_ft = {
				sh = { "shfmt" },
				markdown = { "markdownlint-cli2" },
				go = { "goimports", "gofumpt" },
				python = { "ruff_organize_imports", "ruff_format" },
				lua = { "stylua" },
			},
			formatters = {
				shfmt = {
					append_args = { "-i", "2" },
				},
			},
			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "fallback",
			},
		},
	},
}
