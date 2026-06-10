require("persistence").setup({
	options = {--[[<other options>,]]
		"globals",
	},
	pre_save = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
	end,
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>qr", function() require("persistence").load() end, { desc = "Restore Session" })
vim.keymap.set("n", "<leader>qs", function() require("persistence").select() end, { desc = "Select Session" })
vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore Last Session" })
vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "Don't Save Current Session" })
-- stylua: ignore end
