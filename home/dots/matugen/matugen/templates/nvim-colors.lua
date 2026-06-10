vim.pack.add({ "https://github.com/RRethy/base16-nvim" })

require("base16-colorscheme").setup({
	base00 = "{{colors.background.default.hex}}",
	base01 = "{{colors.surface_container_lowest.default.hex}}",
	base02 = "{{colors.surface_container_low.default.hex}}",
	base03 = "{{colors.outline_variant.default.hex}}",
	base04 = "{{colors.on_surface_variant.default.hex}}",
	base05 = "{{colors.on_surface.default.hex}}",
	base06 = "{{colors.inverse_on_surface.default.hex}}",
	base07 = "{{colors.surface_bright.default.hex}}",
	base08 = "{{colors.tertiary.default.hex | lighten: -5}}",
	base09 = "{{colors.tertiary.default.hex}}",
	base0A = "{{colors.secondary.default.hex}}",
	base0B = "{{colors.primary.default.hex}}",
	base0C = "{{colors.tertiary_container.default.hex}}",
	base0D = "{{colors.primary_container.default.hex}}",
	base0E = "{{colors.secondary_container.default.hex}}",
	base0F = "{{colors.secondary.default.hex | lighten: -10}}",
})

local primary_hex = "{{colors.primary.default.hex}}"
local bg_hex = "{{colors.background.default.hex}}"

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
	fg = "{{colors.outline_variant.default.hex}}",
})
vim.api.nvim_set_hl(0, "FlashLabel", {
	bg = "{{colors.primary.default.hex}}",
	fg = bg_hex,
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashMatch", {
	bg = "{{colors.secondary_container.default.hex}}",
	fg = "{{colors.on_secondary_container.default.hex}}",
})
vim.api.nvim_set_hl(0, "FlashCurrent", {
	bg = "{{colors.tertiary.default.hex}}",
	fg = bg_hex,
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashPrompt", { link = "Normal" })
vim.api.nvim_set_hl(0, "FlashPromptIcon", {
	fg = "{{colors.primary.default.hex}}",
	bold = true,
})
vim.api.nvim_set_hl(0, "FlashCursor", {
	bg = "{{colors.on_surface.default.hex}}",
	fg = bg_hex,
})
