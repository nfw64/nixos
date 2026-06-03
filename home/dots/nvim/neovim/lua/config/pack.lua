-- NOTE: early pack hooks
local modules = {
	"plugins.colorscheme",
	"plugins.lualine",
	"plugins.tmux",
	"plugins.mini",
	"plugins.whichkey",
	"plugins.notify",
}

PckAdd({
	-- deps
	{ src = "BirdeeHub/lze" }, -- lazy load library
	{ src = "kevinhwang91/promise-async" }, --nvim-ufo dependency
	{ src = "MunifTanjim/nui.nvim" }, -- ui library
	{ src = "nvim-lua/plenary.nvim" }, --(used by telescope & git_worktree.nvim)
	{ src = "nvim-tree/nvim-web-devicons" },
	{ src = "rcarriga/nvim-notify" },

	-- Core
	{ src = "christoomey/vim-tmux-navigator" },
	{ src = "echasnovski/mini.nvim" },

	-- ui stu
	{ src = "folke/which-key.nvim" },
	{ src = "nvim-lualine/lualine.nvim" },
	{ src = "scinac/vim-norm-trainer.nvim" },
})

for _, module in ipairs(modules) do
	local status_ok, err = pcall(require, module)
	if not status_ok then
		vim.notify("Failed to load: " .. module .. "\n" .. tostring(err), vim.log.levels.ERROR)
	end
end
