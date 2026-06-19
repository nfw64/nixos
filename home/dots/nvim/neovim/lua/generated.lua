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
	fg = "#524345",
})
vim.api.nvim_set_hl(0, "FlashLabel", {
	bg = "#ffb1c0",
	fg = bg_hex,
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashMatch", {
	bg = "#5b3f44",
	fg = "#ffd9df",
})
vim.api.nvim_set_hl(0, "FlashCurrent", {
	bg = "#ecbe91",
	fg = bg_hex,
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashPrompt", { link = "Normal" })
vim.api.nvim_set_hl(0, "FlashPromptIcon", {
	fg = "#ffb1c0",
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashCursor", {
	bg = "#efdee0",
	fg = bg_hex,
})
