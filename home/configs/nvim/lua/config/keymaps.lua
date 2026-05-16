-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
---- define common options
local opts = {
  noremap = true, -- non-recursive
  silent = true, -- do not show message
}
local map = vim.keymap.set

vim.g.mapleader = " "
-----------------
---- Custom -----
-----------------

-----------------
-- Normal mode --
-----------------

-- Hint: see `:h vim.map.set()`
-- Better window navigation

-- map('n', '<C-Left>',  '<C-w>h',  opts)
-- map('n', '<C-Right>', '<C-w>l',  opts)
map("n", "<C-s>", ":w<CR>", opts)
map("v", "<C-S>", "<esc>:w<cr>")
map("i", "<C-S>", "<esc>:w<cr>")

-- ==============================================================================
-- nvim ctrl+(ad and hl) move windows
-- ==============================================================================
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.keymap.set('n', '<C-a>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-d>', '<C-w>j', { noremap = true, silent = true })

-- ==============================================================================
-- nvim shift+(ad and hl) move buffers
-- ==============================================================================
vim.keymap.set('n', '<S-h>', ':bprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-l>', ':bnext<CR>', { noremap = true, silent = true })

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-----------------
-- Insert mode --
-----------------

map("i", "<C-BS>", "<C-w>", opts)

local status, builtin = pcall(require, "telescope.builtin")
if status then
  vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
end
