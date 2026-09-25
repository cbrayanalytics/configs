return {
	{
		"nvim-neotest/neotest",

		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
			"rcasia/neotest-bash",
			{
				"fredrikaverpil/neotest-golang",
				version = "*",
			},
		},

		keys = {
			{
				"<leader>rr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>rf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run current test file",
			},
			{
				"<leader>rs",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle test summary",
			},
			{
				"<leader>ro",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "Show test output",
			},
			{
				"<leader>rS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop test",
			},
		},

		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-bash"),
					require("neotest-golang")(),
					require("neotest-python")({
						runner = "pytest",
					}),
				},
			})
		end,
	},
}
