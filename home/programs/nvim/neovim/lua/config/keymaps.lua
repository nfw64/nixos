local opts = {
  noremap = true, -- non-recursive
  silent = true, -- do not show message
}

--------------------
-- some qol binds --
--------------------

-- ctrl s save every mode
vim.keymap.set("n", "<C-s>", ":w<CR>", opts)
vim.keymap.set("v", "<C-S>", "<esc>:w<cr>")
vim.keymap.set("i", "<C-S>", "<esc>:w<cr>")

-----------------
-- Insert mode --
-----------------

-- backwards by one word in insert mode
vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move left one character" })
-- forward by one char in insert mode
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Jump to end of line" })

-----------------
-- Normal mode --
-----------------


-- ^ and $ is too awkward lol
vim.keymap.set({'n', 'v', 'o'}, 'gh', '^', { desc = 'Go to start of line' })
vim.keymap.set({'n', 'v', 'o'}, 'gl', '$', { desc = 'Go to end of line' })

-- ==============================================================================
-- nvim ctrl+(ad and hl) move windows
-- use if not using tmux vim navigator plugin
-- ==============================================================================
--vim.keymap.set('n', '<C-h>', '<C-w>h',  opts)
--vim.keymap.set('n', '<C-l>', '<C-w>l',  opts)
--vim.keymap.set('n', '<C-a>', '<C-w>k',  opts)
--vim.keymap.set('n', '<C-d>', '<C-w>j',  opts)

-- ==============================================================================
-- nvim shift+(ad and hl) move buffers
-- ==============================================================================
vim.keymap.set('n', '<S-h>', ':bprevious<CR>',  opts)
vim.keymap.set('n', '<S-l>', ':bnext<CR>', opts)

-----------------
-- Visual mode --
-----------------

-- Hint: start visual mode with the same area as the previous area and the same mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Telescope
local status, builtin = pcall(require, "telescope.builtin")
if status then
  vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
end
