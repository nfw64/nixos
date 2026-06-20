vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true
-- Disable line numbers ON terminal
vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter" }, {
	group = vim.api.nvim_create_augroup("TerminalSettings", { clear = true }),
	callback = function()
		-- Only strip numbers if the buffer actually holds a terminal
		if vim.bo.buftype == "terminal" then
			vim.wo.number = false
			vim.wo.relativenumber = false
		end
	end,
})

-- indentation
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.wrap = false

-- backup and undo
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true

-- search
vim.opt.inccommand = "split"

-- UI
vim.o.showcmd = true
vim.o.statuscolumn = "%s %l %C"
vim.opt.cmdheight = 0
vim.opt.cursorcolumn = false
vim.opt.fillchars:append({ eob = " " })
vim.opt.scrolloff = 8
vim.opt.showmode = false -- Hides the redundant '-- INSERT --' text
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true
vim.opt.winborder = "single"

-- folding (for nvim-ufo)
vim.o.foldcolumn = "0"
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldmethod = "manual"

-- window splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- misc
vim.cmd([[hi @lsp.type.number gui=bold]])
vim.cmd([[set noswapfile]])
vim.g.lsp_defaults = false
vim.o.sidescroll = 1
vim.o.sidescrolloff = 0
vim.o.commentstring = ""
vim.opt.clipboard:append("unnamedplus")
vim.opt.showtabline = 0
vim.opt.colorcolumn = "0"
vim.opt.confirm = true
vim.opt.isfname:append("@-@")
vim.opt.mouse = "a"
vim.opt.timeoutlen = 250
vim.opt.ttm = 50
vim.opt.updatetime = 50

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})
