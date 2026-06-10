local wk = require("which-key")

wk.setup({
	preset = "modern",
	delay = 0,
	plugins = {
		spelling = {
			enabled = false, -- Prevents Neovim from waiting for spell suggestions
		},
	},
})

wk.add({
	-- Set the initial global mode block cleanly for this array
	mode = { "n", "x" },

	-- Structure: { LHS, group = "NAME", icon = { icon = "ICON", color = "COLOR" } }
  -- stylua: ignore start
	{ "<leader><tab>", group = "tabs", icon = { icon = "󰓩 ", color = "cyan" }, expand = function() return require("which-key.extras").expand.buf() end,},
	{ "<leader>\\", group = "explorer", icon = { icon = "󰣞", color = "red" } },
	{ "<leader>c", group = "code", icon = { icon = "", color = "orange" } },
	{ "<leader>e", group = "files", icon = { icon = "", color = "red" } },
	{ "<leader>f", group = "text", icon = { icon = "󰦨", color = "green" } },
	{ "<leader>g", group = "git", icon = { icon = "", color = "purple" } },
	{ "<leader>gh", group = "hunks", icon = { icon = "", color = "purple" } },
	{ "<leader>i", group = "pickers", icon = { icon = "", color = "red" } },
	{ "<leader>l", group = "lsp", icon = { icon = "", color = "azure" } },
	{ "<leader>lm", group = "lsp/management", icon = { icon = "", color = "red" } },
	{ "<leader>m", group = "marks/management", icon = { icon = "", color = "red" } },
	{ "<leader>n", group = "noice/messages", icon = { icon = "󰈸", color = "orange" } },
	{ "<leader>p", group = "picker", icon = { icon = "", color = "green" } },
	{ "<leader>q", group = "quit/session", icon = { icon = "󰍂", color = "red" } },
	{ "<leader>r", group = "nvim", icon = { icon = "", color = "green" } },
	{ "<leader>s", group = "search", icon = { icon = "", color = "yellow" } },
	{ "<leader>t", group = "todo", icon = { icon = "", color = "cyan" } },
	{ "<leader>u", group = "ui", icon = { icon = "  ", color = "azure" } },
	{ "<leader>v", group = "manpages", icon = { icon = "󰋖", color = "green" } },
	{ "<leader>x", group = "Kill tab", icon = { icon = "", color = "red" } },
	-- stylua: ignore end
	-- Structural or Navigation Groups
	{ "[", group = "prev", icon = { icon = "", color = "grey" } },
	{ "]", group = "next", icon = { icon = "", color = "grey" } },
	{ "g", group = "goto", icon = { icon = "➔", color = "grey" } },
	{ "gs", group = "surround", icon = { icon = "  ", color = "orange" } },
	{ "z", group = "fold", icon = { icon = "  ", color = "yellow" } },

	-- Dynamic Expansion Blocks
	{
		"<leader>w",
		group = "windows",
		proxy = "<c-w>",
		icon = { icon = "", color = "blue" },
		expand = function()
			return require("which-key.extras").expand.win()
		end,
	},

	-- Individual Mappings
	{ "gx", desc = "Open with system app", icon = { icon = "  ", color = "grey" } },
	{ "<leader>qq", "<cmd>q<cr>", desc = "Quit", mode = { "n", "v" }, icon = { icon = "", color = "red" } },
	-- stylua: ingore
	{ "<leader>qQ", "<cmd>qa!<cr>", desc = "Quit", mode = { "n", "v" }, icon = { icon = "", color = "red" } },
	{ "<leader>rs", icon = { icon = "󱄌", color = "green" } },
	{ "<leader>re", icon = { icon = "", color = "green" } },
})
