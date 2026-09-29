local group = vim.api.nvim_create_augroup("personal_config", { clear = true })

vim.opt.viewoptions = { "folds", "cursor" }

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	desc = "Highlight copied text",
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "BufWinLeave", "BufWritePost" }, {
	group = group,
	desc = "Save folds and cursor position",
	pattern = "?*",
	callback = function(args)
		if vim.bo[args.buf].buftype == "" and vim.fn.expand("%") ~= "" then
			vim.cmd("silent! mkview")
		end
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = group,
	desc = "Restore folds and cursor position",
	pattern = "?*",
	callback = function(args)
		if vim.bo[args.buf].buftype == "" then
			vim.cmd("silent! loadview")
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	desc = "Show full rendered headings on folded lines",
	pattern = "markdown",
	callback = function()
		vim.opt_local.foldtext = ""
	end,
})
