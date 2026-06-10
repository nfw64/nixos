-- NOTE: early pack hooks
local modules = {
	"plugins.colorscheme",
	"plugins.tmux",
	"plugins.mini",
	"plugins.whichkey",
}

PckAdd({
	-- deps
	{ src = "BirdeeHub/lze" }, -- lazy load library
	{ src = "kevinhwang91/promise-async" }, --nvim-ufo dependency
	{ src = "MunifTanjim/nui.nvim" }, -- ui library
	{ src = "nvim-tree/nvim-web-devicons" }, -- icons

	-- Core
	{ src = "christoomey/vim-tmux-navigator" },
	{ src = "echasnovski/mini.nvim" },

	-- ui stu
	{ src = "folke/which-key.nvim" },
})

for _, module in ipairs(modules) do
	local status_ok, err = pcall(require, module)
	if not status_ok then
		vim.notify("Failed to load: " .. module .. "\n" .. tostring(err), vim.log.levels.ERROR)
	end
end
