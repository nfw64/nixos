-- Bubbles config for lualine
-- Author: lokesh-krishna
-- MIT license, see LICENSE for more details.

local mode = {
	"mode",
	fmt = function(str)
		return "" .. str
	end,
}

local diff = {
	"diff",
	colored = true,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
	-- cond = hide_in_width,
}

local filename = {
	"filename",
	file_status = true,
	path = 0,
}

local branch = { "branch", icon = { "", color = { fg = "#A6D4DE" } }, "|" }

require("lualine").setup({
	icons_enabled = true,
	options = {
		theme = auto,
		component_separators = { left = "|", right = "|" },
		section_separators = { left = "|", right = "" },
	},
	sections = {
		lualine_a = { mode },
		lualine_b = { branch },
		lualine_c = { diff, filename },
		lualine_x = {
			{
				require("noice").api.statusline.mode.get,
				cond = require("noice").api.statusline.mode.has,
				color = { fg = "#ff9e64" },
			},
			{ "fileformat" },
			{ "filetype" },
		},
	},
})
