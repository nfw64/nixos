local fzf = require("fzf-lua")
fzf.setup({
	-- Path display smart equivalent: shrinks parent directories
	path_shorten = 1,

	winopts = {
		height = 0.50,
		width = 0.95,
		row = 0.50,
		col = 0.50,
		border = "single",
		backdrop = 70,
		treesitter = {
			enabled = true,
			fzf_colors = { ["hl"] = "-1:reverse", ["hl+"] = "-1:reverse" },
		},
		preview = {
			border = "single",
			wrap = true,
			hidden = false,
			vertical = "down:45%",
			horizontal = "right:50%",
			layout = "horizontal",

			title = false,
			scrollbar = "border",
			delay = 20,
			winopts = {
				number = false,
				relativenumber = false,
			},
		},
	},

	-- Custom Keymaps inside the FZF prompt window
	keymap = {
		-- Below are the default binds, setting any value in these tables will override
		-- the defaults, to inherit from the defaults change [1] from `false` to `true`
		builtin = {
			["<C-q>"] = "hide", -- hide fzf-lua, `:FzfLua resume` to continue
			["?"] = "toggle-help",
			["<F2>"] = "nop",
			["<C-p>"] = "toggle-preview",
			["<F6>"] = "toggle-preview-behavior",
			["<F7>"] = "toggle-preview-ts-ctx",
			["<F8>"] = "preview-ts-ctx-dec",
			["<F9>"] = "preview-ts-ctx-inc",
			["<C-d>"] = "preview-page-down",
			["<C-u>"] = "preview-page-up",
			["<M-S-j>"] = "preview-down",
			["<M-S-k>"] = "preview-up",
			["<space>"] = false,
		},
	},
	actions = {
		files = {
			true,
			["enter"] = FzfLua.actions.file_edit_or_qf,
			["alt-s"] = FzfLua.actions.file_split,
			["alt-w"] = FzfLua.actions.file_vsplit,
			["alt-q"] = FzfLua.actions.file_sel_to_qf,
			["alt-Q"] = FzfLua.actions.file_sel_to_ll,
			["alt-i"] = FzfLua.actions.toggle_ignore,
			["alt-h"] = FzfLua.actions.toggle_hidden,
			["alt-f"] = FzfLua.actions.toggle_follow,
		},
	},
	previewers = {
		cat = {
			cmd = "cat",
			args = "-n",
		},
		bat = {
			cmd = "bat",
			args = "--color=always --style=numbers,changes",
		},
		head = {
			cmd = "head",
			args = nil,
		},
		git_diff = {
			cmd_deleted = "git diff --color HEAD --",
			cmd_modified = "git diff --color HEAD",
			cmd_untracked = "git diff --color --no-index /dev/null",
		},
		man = {
			cmd = "man -c %s | col -bx",
		},
		builtin = {
			syntax = true, -- preview syntax highlight?
			syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
			syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
			limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
			treesitter = {
				enabled = true,
				disabled = {},
				context = { max_lines = 1, trim_scope = "inner" },
			},
			toggle_behavior = "default",
			extensions = {
				-- neovim terminal only supports `viu` block output
				["png"] = { "viu", "-b" },
				-- by default the filename is added as last argument
				-- if required, use `{file}` for argument positioning
				["svg"] = { "chafa", "{file}" },
				["jpg"] = { "ueberzug" },
			},
			ueberzug_scaler = "cover",
			render_markdown = { enabled = true, filetypes = { ["markdown"] = true } },
		},
		codeaction = {
			diff_opts = { ctxlen = 3 },
		},
	},
	files = {
		color_icons = false, -- colorize file|git icons
	},
})

vim.keymap.set("n", "<leader>iR", "<cmd>FzfLua resume<cr>", { desc = "Resume Last Search" })
