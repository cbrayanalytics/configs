vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Save
map({ "n", "i" }, "<C-s>", "<cmd>write<cr>", { desc = "Save file" })

-- Better window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Window splits
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>wh", "<cmd>split<cr>",  { desc = "Horizontal split" })
map("n", "<leader>wq", "<cmd>close<cr>",  { desc = "Close window" })

-- Resize windows with arrows
map("n", "<C-Up>",    "<cmd>resize +2<cr>",          { desc = "Increase window height" })
map("n", "<C-Down>",  "<cmd>resize -2<cr>",          { desc = "Decrease window height" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Keep cursor centered when jumping
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Jump to line start/end
map({ "n", "v" }, "H", "^", { desc = "Jump to line start" })
map({ "n", "v" }, "L", "$", { desc = "Jump to line end" })

-- Paste without overwriting register in visual mode
map("v", "p", '"_dP')

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better indenting in visual mode (keeps selection)
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("n", "<leader>tt", "<cmd>terminal<cr>", { desc = "Open terminal" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Buffers
map("n", "<leader>bn", "<cmd>enew<cr>",    { desc = "New buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Close buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>",{ desc = "Force close buffer" })
