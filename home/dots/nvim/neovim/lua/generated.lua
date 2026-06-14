vim.pack.add({ "https://github.com/RRethy/base16-nvim" })

require("base16-colorscheme").setup({
	base00 = "#121318",
	base01 = "#0d0e13",
	base02 = "#1a1b21",
	base03 = "#45464f",
	base04 = "#c5c6d0",
	base05 = "#e3e2e9",
	base06 = "#2f3036",
	base07 = "#38393f",
	base08 = "#d9a9d3",
	base09 = "#e1bbdc",
	base0A = "#c0c6dd",
	base0B = "#b2c5ff",
	base0C = "#5a3d59",
	base0D = "#314578",
	base0E = "#404659",
	base0F = "#9fa8cb",
})

local primary_hex = "#b2c5ff"
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
	fg = "#45464f",
})
vim.api.nvim_set_hl(0, "FlashLabel", {
	bg = "#b2c5ff",
	fg = bg_hex,
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashMatch", {
	bg = "#404659",
	fg = "#dce2f9",
})
vim.api.nvim_set_hl(0, "FlashCurrent", {
	bg = "#e1bbdc",
	fg = bg_hex,
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashPrompt", { link = "Normal" })
vim.api.nvim_set_hl(0, "FlashPromptIcon", {
	fg = "#b2c5ff",
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashCursor", {
	bg = "#e3e2e9",
	fg = bg_hex,
})
