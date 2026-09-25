local group = vim.api.nvim_create_augroup("personal_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight copied text",
  callback = function()
    vim.highlight.on_yank()
  end,
})
