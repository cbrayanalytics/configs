local M = {}

local session_dir = vim.fn.stdpath("state") .. "/sessions"

vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
}

local function session_file()
  local cwd = vim.fn.getcwd()
  return session_dir .. "/" .. vim.fn.sha256(cwd) .. ".vim"
end

local function has_modified_buffers()
  for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buffer) and vim.bo[buffer].modified then
      return true
    end
  end

  return false
end

function M.save()
  vim.fn.mkdir(session_dir, "p")
  vim.cmd("mksession! " .. vim.fn.fnameescape(session_file()))
  vim.notify("Session saved for " .. vim.fn.getcwd())
end

function M.restore()
  local file = session_file()

  if vim.fn.filereadable(file) == 0 then
    vim.notify("No session exists for " .. vim.fn.getcwd(), vim.log.levels.WARN)
    return
  end

  if has_modified_buffers() then
    vim.notify("Save or discard modified buffers before restoring", vim.log.levels.WARN)
    return
  end

  vim.cmd("source " .. vim.fn.fnameescape(file))
  vim.notify("Session restored for " .. vim.fn.getcwd())
end

vim.keymap.set("n", "<leader>ss", M.save, {
  desc = "Save project session",
})

vim.keymap.set("n", "<leader>sr", M.restore, {
  desc = "Restore project session",
})

return M
