vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("i", "jj", "<Esc>", { desc = "Exit insert mode" })

map("n", "<leader><leader>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
vim.keymap.set("n", "<leader>|", "<cmd>vsplit<cr>", {
  desc = "Split window vertically",
})

map("n", "<leader>-", "<cmd>split<cr>", {
  desc = "Split window horizontally",
})

map("n", "<leader><Tab><Tab>", "<cmd>tabnew<cr>", {
  desc = "New tab",
})

map("n", "<leader><Tab>q", "<cmd>tabclose<cr>", {
  desc = "Close tab",
})

map("n", "<leader><Tab>]", "<cmd>tabnext<cr>", {
  desc = "Next tab",
})

map("n", "<leader><Tab>[", "<cmd>tabprevious<cr>", {
  desc = "Previous tab",
})
