local opts = {
	noremap = true, -- non-recursive
	silent = true, -- do not show message
}
local wk = require("which-key")

wk.add({

	{ "<leader>rc", group = "configuration" },
	{ "<leader>rce", ":tabedit $MYVIMRC<CR>", desc = "Edit init.lua in new tab" },
	{ "<leader>rcs", ":source %<cr>", desc = "Source current file" },
	{ "<leader>b", "<cmd>bp|bd #<CR>", desc = "Quit current buffer" },
})

-- restart
vim.keymap.set("n", "<leader>rs", "<cmd>restart<cr>", { desc = "Restart Neovim (:restart)" })
vim.keymap.set("n", "<leader>re", "<cmd>e %<cr>", { desc = "Restart current buffer" })

-----------------
--  Terminal   --
-----------------

vim.keymap.set("t", "<C-q><C-q>", [[<C-\><C-n>]], { desc = "which_key_ignore" })
-----------------
--   Cmdline   --
-----------------
vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Previous command history" })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Next command history" })

----------------
--  Mixed mode --
-----------------

vim.keymap.set({ "n", "v", "o" }, "gh", "^", { desc = "Go to start of line" })
vim.keymap.set({ "n", "v", "o" }, "gl", "$", { desc = "Go to end of line" })
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<ESC>:w<cr>")

vim.keymap.set({ "n" }, "<Leader>x", "<Cmd>close<CR>", { desc = "Close tab" })

-----------------
-- Visual mode --
-----------------

vim.keymap.set("x", "p", [["_dP]])

-- manual format
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

-----------------
-- Insert mode --
-----------------

vim.keymap.set("i", "<S-tab>", "<Right>", { desc = "Move right one character" })

-----------------
-- Normal mode --
-----------------
vim.keymap.set("n", "S", "<Nop>", { noremap = true, silent = true })

--- marks management
vim.keymap.set(
	"n",
	"<leader>mdA",
	":delmarks! | delmarks A-Z 0-9 | wshada!<cr>",
	{ noremap = true, silent = true, desc = "Delete ALL" }
)
vim.keymap.set("n", "<leader>mda", ":delmarks a-z", { noremap = true, silent = true, desc = "Delete local marks only" })

-- quality of life
vim.keymap.set("n", "=ap", "ma=ap'a") -- retain cursor position when indenting paragraph

-- Forces visual paste to remain inline and preserves your clipboard
vim.keymap.set("x", "p", "P")

--- Centerss
-- use neoscrolling?
-- vim.keymap.set("n", "<C-d>", "<C-d>zz") -- center screen half screen down
-- vim.keymap.set("n", "<C-u>", "<C-u>zz") -- center screen half screen up
vim.keymap.set("n", "n", "nzzzv") -- center search results
vim.keymap.set("n", "N", "Nzzzv") -- center search results

vim.keymap.set("n", "J", "mzJ`z :delmark z<cr>") -- keep cursor position after join lines

vim.keymap.set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make executable" })
vim.keymap.set("n", "<Esc>", "<cmd>noh<cr>", { desc = "Clear highlights and disable n/N keys" })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste (no replace)" })

-- prevent x delete from registering when next paste
vim.keymap.set("n", "x", '"_x', opts)

-- Open split terminal
vim.keymap.set({ "n", "t" }, "<C-q><C-w>", "<cmd>Floatterm<cr>", { desc = "which_key_ignore" })

-- move buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", opts)
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", opts)

-- Replace the word cursor is on globally
vim.keymap.set(
	"n",
	"<leader>sa",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word cursor is on globally" }
)

vim.keymap.set("n", "<leader>ss", [[:%s///gcI<Left><Left><Left><Left><Left>]], { desc = "Replace word" })

vim.keymap.set(
	"n",
	"<leader>sr",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gcI<Left><Left><Left><Left>]],
	{ desc = "Replace word cursor" }
)

-- format with built in
vim.keymap.set("n", "<leader>fl", vim.lsp.buf.format, { desc = "Format text(LSP)" })

-- Unmaps Q in normal mode
vim.keymap.set("n", "Q", "<nop>")

-- prevent x delete from registering when next paste
vim.keymap.set("n", "x", '"_x', opts)
