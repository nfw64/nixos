vim.pack.add({ "https://github.com/RRethy/base16-nvim" })

require("base16-colorscheme").setup({
	base00 = "#0e1415",
	base01 = "#090f10",
	base02 = "#161d1d",
	base03 = "#3f4949",
	base04 = "#bec8c9",
	base05 = "#dde4e4",
	base06 = "#2b3232",
	base07 = "#343a3b",
	base08 = "#a2b8e3",
	base09 = "#b6c7e9",
	base0A = "#b1cccd",
	base0B = "#80d4d9",
	base0C = "#364764",
	base0D = "#004f53",
	base0E = "#324b4d",
	base0F = "#92b8b9",
})

local primary_hex = "#80d4d9"
local bg_hex = "#0e1415"

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
	fg = "#3f4949",
})
vim.api.nvim_set_hl(0, "FlashLabel", {
	bg = "#80d4d9",
	fg = bg_hex,
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashMatch", {
	bg = "#324b4d",
	fg = "#cce8e9",
})
vim.api.nvim_set_hl(0, "FlashCurrent", {
	bg = "#b6c7e9",
	fg = bg_hex,
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashPrompt", { link = "Normal" })
vim.api.nvim_set_hl(0, "FlashPromptIcon", {
	fg = "#80d4d9",
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashCursor", {
	bg = "#dde4e4",
	fg = bg_hex,
})
