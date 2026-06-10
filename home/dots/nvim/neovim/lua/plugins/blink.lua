require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust" },
	keymap = {
		preset = "none",

		["<Tab>"] = { "accept", "select_next", "fallback" },
		["<C-l>"] = { "accept", "fallback" },
		["<C-cr>"] = { "accept", "fallback" },

		["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
		["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },

		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-h>"] = { "hide" },
	},

	cmdline = {
		enabled = true,
		keymap = { preset = "inherit" }, -- Ensures cmdline defaults don't conflict
		completion = {
			menu = { auto_show = true },
		},
	},

	-- editor insert mode completions
	completion = {
		menu = {
			auto_show = true, -- show on type
		},
		documentation = {
			auto_show = true, -- show function signature/docs
		},
		ghost_text = {
			enabled = false,
			show_with_menu = false,
		},
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
	},

	sources = {
		default = { "lsp", "path", "buffer", "snippets" },
		providers = {
			lsp = {
				opts = {
					tailwind_color_icon = "  ",
				},
			},
		},
	},

	appearance = {
		use_nvim_cmp_as_default = false,
		nerd_font_variant = "mono",
	},

	snippets = {
		preset = "luasnip",
	},
})

require("luasnip.loaders.from_vscode").lazy_load() -- load friendly snippets collection
