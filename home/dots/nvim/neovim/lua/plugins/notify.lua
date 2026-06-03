require("notify").setup({
	render = "wrapped-compact",
	stages = "fade_in_slide_out",
	max_width = 60,
	timeout = 2000,
	merge_duplicates = true,
	on_open = function(win)
		local config = vim.api.nvim_win_get_config(win)
		config.border = "single"
		vim.api.nvim_win_set_config(win, config)
	end,
})

-- Override the default Neovim notification engine
vim.notify = require("notify")
