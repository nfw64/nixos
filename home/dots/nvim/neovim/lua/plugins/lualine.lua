local ok, base16 = pcall(require, "base16-colorscheme")
local colors = ok and base16.colors or {}

require("lualine").setup({
	icons_enabled = true,
	options = {
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
	},
	extensions = {
		"oil",
		"fzf",
		"fugitive",
	},

	winbar = {
		lualine_b = {
			{
				"buffers",
				buffers_color = {
					active = { fg = colors.base0F },
					inactive = { fg = colors.base0D },
				},
				symbols = {
					alternate_file = "",
				},
			},
		},
		lualine_x = {
			{ "diagnostics" },
			{ "lsp_status" },
		},
	},
	sections = {
		lualine_a = {
			{
				"mode",
				fmt = function(str)
					return "" .. str
				end,
			},
		},
		lualine_b = {
			{
				"branch",
				draw_empty = false,
				icon = { "", color = { fg = "#A6D4DE" } },
			},
		},
		lualine_c = {
			{
				"diff",
				colored = true,
				symbols = { added = " ", modified = " ", removed = " " },
			},
		},
		lualine_x = {
			{ "filetype" },
		},
	},
})
