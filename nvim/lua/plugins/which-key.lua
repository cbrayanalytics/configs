return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			delay = 400,
			icons = { mappings = true },
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.add({
				{ "<leader>b", group = "buffers" },
				{ "<leader>f", group = "find" },
				{ "<leader>h", group = "git hunks" },
				{ "<leader>c", group = "code" },
				{ "<leader>w", group = "windows" },
				{ "<leader>t", group = "terminal" },
			})
		end,
	},
}
