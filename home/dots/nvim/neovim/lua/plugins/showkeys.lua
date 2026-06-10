require("showkeys").setup({
	position = "top-right",
	timeout = 1,
	maxkeys = 3,
	show_count = true,
	excluded_modes = { "i" },
	winopts = {
		focusable = false,
		relative = "editor",
		style = "minimal",
		border = "single",
		height = 1,
		row = 25,
		col = 0,
	},
})

vim.keymap.set("n", "<leader>ks", "<cmd>ShowkeysToggle<CR>", {
	desc = "Toggle Showkeys",
})
