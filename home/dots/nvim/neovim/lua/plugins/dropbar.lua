local dropbar_api = require("dropbar.api")
local utils = require("dropbar.utils")
require("dropbar").setup({
	-- Modify interactive menu settings (when you click or trigger dropbar)
	menu = {
		keymaps = {
			["<CR>"] = function()
				local menu = utils.menu.get_current()
				if not menu then
					return
				end
				local cursor = vim.api.nvim_win_get_cursor(menu.win)
				local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
				if component then
					menu:click_on(component, nil, 1, "l")
				end
			end,
			["<S-h>"] = "<C-w>q",
			["<S-l>"] = function()
				local menu = utils.menu.get_current()
				if not menu then
					return
				end
				local cursor = vim.api.nvim_win_get_cursor(menu.win)
				local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
				if component then
					menu:click_on(component, nil, 1, "l")
				end
			end,
			["q"] = "<C-w>q",
			["<Esc>"] = "<C-w>q",
		},
	},
})

vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
