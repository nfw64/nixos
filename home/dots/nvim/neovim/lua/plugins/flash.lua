require("flash").setup({
	labels = "asdfhjklg",
	search = {
		multi_window = true,
		forward = true,
		wrap = true,
		mode = "exact",
		exclude = {
			"notify",
			"cmp_menu",
			"noice",
			"flash_prompt",
			function(win)
				-- exclude non-focusable windows
				return not vim.api.nvim_win_get_config(win).focusable
			end,
		},
	},
	jump = {
		nohlsearch = true,
		autojump = true,
	},
	label = {
		uppercase = false,
		style = "overlay",
	},
	modes = {
		char = {
			enabled = true,
			keys = { "f", "F", "t", "T", ";", "," },
			highlight = { backdrop = false },
		},
		treesitter = {
			labels = "asdfhjklg;",
			highlight = {
				backdrop = true,
			},
		},
		treesitter_search = {
			jump = { pos = "range" },
			search = { multi_window = true, wrap = true, incremental = false },
			remote_op = { restore = true },
			label = { before = true, after = true, style = "inline" },
		},
	},
})
