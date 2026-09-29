local jdtls = require("jdtls")

local root_dir = vim.fs.root(0, {
	".git",
	"mvnw",
	"gradlew",
	"pom.xml",
	"build.gradle",
	"build.gradle.kts",
}) or vim.fn.getcwd()

local project_name = vim.fs.basename(root_dir)
local workspace_name = project_name .. "-" .. vim.fn.sha256(root_dir):sub(1, 8)
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. workspace_name

vim.fn.mkdir(workspace_dir, "p")

local function map(mode, lhs, rhs, description, bufnr)
	vim.keymap.set(mode, lhs, rhs, {
		buffer = bufnr,
		desc = description,
		silent = true,
	})
end

jdtls.start_or_attach({
	cmd = {
		vim.fn.exepath("jdtls"),
		"-data",
		workspace_dir,
	},
	root_dir = root_dir,
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			maven = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
			},
		},
	},
	on_attach = function(_, bufnr)
		map("n", "<leader>co", jdtls.organize_imports, "Organize imports", bufnr)

		map("n", "<leader>cxv", jdtls.extract_variable, "Extract variable", bufnr)
		map("x", "<leader>cxv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", "Extract variable", bufnr)

		map("n", "<leader>cxc", jdtls.extract_constant, "Extract constant", bufnr)
		map("x", "<leader>cxc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", "Extract constant", bufnr)

		map("x", "<leader>cxm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", "Extract method", bufnr)

		local ok, which_key = pcall(require, "which-key")
		if ok then
			which_key.add({
				{
					"<leader>cx",
					group = "Extract",
					buffer = bufnr,
				},
			})
		end
	end,
})
