-- HACK: docs @ https://github.com/folke/snacks.nvim/blob/main/docs

require("snacks").setup({
	styles = {
		input = {
			keys = {
				n_esc = { "<C-c>", { "cmp_close", "cancel" }, mode = "n", expr = true },
				i_esc = { "<C-c>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
			},
		},
	},

	indent = { enabled = true },
	notifier = { enabled = true },
	scope = { enabled = true },
	scroll = { enabled = true },
	statuscolumn = { enabled = true }, -- we set this in options.lua
	words = { enabled = true },

	-- Snacks Modules
	input = { enabled = true },
	quickfile = {
		enabled = true,
		exclude = { "latex" },
	},

	picker = {
		enabled = false,
	},

	image = {
		enabled = function()
			return vim.bo.filetype == "markdown"
		end,
		doc = {
			float = false,
			inline = false,
			max_width = 50,
			max_height = 30,
			wo = { wrap = false },
		},
		convert = {
			notify = true,
			command = "magick",
		},
		img_dirs = {
			"img",
			"images",
			"assets",
			"static",
			"public",
			"media",
			"attachments",
			"Archives/All-Vault-Images/",
			"~/Library",
			"~/Downloads",
		},
	},

	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			{
				text = {
					{ " " },
					{ "󰒲  Loaded with vim.pack • Neovim 0.12", hl = "SnacksDashboardFooter" },
				},
				padding = 2,
			},
		},
	},
})

-- stylua: ignore start 
-- Git
vim.keymap.set("n", "<leader>glg", function() require("snacks").lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gll", function() require("snacks").lazygit.log() end, { desc = "Lazygit Logs" })
vim.keymap.set("n", "<leader>gbr", function() require("snacks").picker.git_branches({ layout = "select" }) end, { desc = "Pick and Switch Git Branches" })

-- Other Utils
vim.keymap.set("n", "<leader>vh", function() require("snacks").picker.help() end, { desc = "Help Pages" })

-- todo-comments w/ Snacks
vim.keymap.set("n", "<leader>tt", function() require("snacks").picker.todo_comments() end, { desc = "All" })
vim.keymap.set("n", "<leader>tT", function() require("snacks").picker.todo_comments({ keywords = { "TODO", "FORGETNOT", "FIXME", "!" } }) end, { desc = "mains" })
-- stylua: ignore end
