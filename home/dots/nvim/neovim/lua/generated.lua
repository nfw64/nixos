vim.pack.add({ "https://github.com/RRethy/base16-nvim" })

require("base16-colorscheme").setup({
	base00 = "#121318",
	base01 = "#0d0e13",
	base02 = "#1b1b21",
	base03 = "#46464f",
	base04 = "#c6c5d0",
	base05 = "#e3e1e9",
	base06 = "#303036",
	base07 = "#38393f",
	base08 = "#dea7ce",
	base09 = "#e5bad8",
	base0A = "#c3c5dd",
	base0B = "#bac3ff",
	base0C = "#5d3c55",
	base0D = "#394379",
	base0E = "#434659",
	base0F = "#a2a6cb",
})

local primary_hex = "#bac3ff"
local bg_hex = "#121318"

local function mix(hex1, hex2, w)
	local c1, c2 = tonumber(hex1:gsub("#", ""), 16), tonumber(hex2:gsub("#", ""), 16)
  -- stylua: ignore
	local function ch(shift) return math.floor((bit.band(bit.rshift(c1, shift), 255) * w) + (bit.band(bit.rshift(c2, shift), 255) * (1 - w))) end
	return string.format("#%02x%02x%02x", ch(16), ch(8), ch(0))
end

local darker_visual_bg = mix(primary_hex, bg_hex, 0.50)

-- visual colors
vim.api.nvim_set_hl(0, "Visual", {
	bg = darker_visual_bg,
	fg = bg_hex,
})

-- flash nvim colors
vim.api.nvim_set_hl(0, "FlashBackdrop", {
	fg = "#46464f",
})
vim.api.nvim_set_hl(0, "FlashLabel", {
	bg = "#bac3ff",
	fg = bg_hex,
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashMatch", {
	bg = "#434659",
	fg = "#dfe1f9",
})
vim.api.nvim_set_hl(0, "FlashCurrent", {
	bg = "#e5bad8",
	fg = bg_hex,
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashPrompt", { link = "Normal" })
vim.api.nvim_set_hl(0, "FlashPromptIcon", {
	fg = "#bac3ff",
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashCursor", {
	bg = "#e3e1e9",
	fg = bg_hex,
})
