vim.pack.add({ "https://github.com/RRethy/base16-nvim" })

require("base16-colorscheme").setup({
	base00 = "#191113",
	base01 = "#140c0d",
	base02 = "#22191b",
	base03 = "#524345",
	base04 = "#d6c2c4",
	base05 = "#efdee0",
	base06 = "#382e2f",
	base07 = "#413738",
	base08 = "#e8b17b",
	base09 = "#ecbe91",
	base0A = "#e4bdc3",
	base0B = "#ffb1c0",
	base0C = "#5f401d",
	base0D = "#713342",
	base0E = "#5b3f44",
	base0F = "#d599a2",
})

local primary_hex = "#ffb1c0"
local bg_hex = "#191113"

local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")
	return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

local p_r, p_g, p_b = hex_to_rgb(primary_hex)
local b_r, b_g, b_b = hex_to_rgb(bg_hex)
local mix_factor = 0.50
local final_r = math.floor(p_r * mix_factor + b_r * (1 - mix_factor))
local final_g = math.floor(p_g * mix_factor + b_g * (1 - mix_factor))
local final_b = math.floor(p_b * mix_factor + b_b * (1 - mix_factor))
local darker_visual_bg = string.format("#%02x%02x%02x", final_r, final_g, final_b)

vim.api.nvim_set_hl(0, "Visual", {
	bg = darker_visual_bg,
	fg = bg_hex,
})

local base16_ts_fix = vim.api.nvim_create_augroup("Base16ResetTS", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = base16_ts_fix,
	pattern = "base16-*",
	callback = function()
		-- High-impact groups that base16 washes out into a single flat color
		local problematic_groups = {
			"@variable",
			"@variable.builtin",
			"@property",
			"@field",
			"@parameter",
			"@attribute",
			"@namespace",
		}

		-- Delete the base16 highlight definitions for these groups
		-- This forces Neovim to use standard, working syntax fallback groups
		for _, group in ipairs(problematic_groups) do
			vim.api.nvim_set_hl(0, group, {})
		end
	end,
})
