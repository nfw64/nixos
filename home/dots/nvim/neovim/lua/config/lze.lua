PckAdd({
	--  LSP
	{ src = "neovim/nvim-lspconfig" },
	{ src = "saghen/blink.cmp" },
	{ src = "mfussenegger/nvim-lint" },
	{ src = "folke/lazydev.nvim" },
	{ src = "saghen/blink.lib" },
	{ src = "L3MON4D3/LuaSnip" },
	{ src = "rafamadriz/friendly-snippets" },

	--  Code helpers
	{ src = "ibhagwan/fzf-lua" },
	{ src = "windwp/nvim-autopairs" },
	{ src = "kevinhwang91/nvim-ufo" },
	{ src = "folke/todo-comments.nvim" },
	{ src = "stevearc/conform.nvim" },
	{ src = "nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/folke/flash.nvim" },

	-- Treesitter
	{ src = "JoosepAlviste/nvim-ts-context-commentstring" },
	{ src = "windwp/nvim-ts-autotag" },
	{ src = "romus204/tree-sitter-manager.nvim" },
	-- UI related
	{ src = "nvim-lualine/lualine.nvim" },
	{ src = "NvChad/nvim-colorizer.lua" }, -- hex or rgb color in buff
	{ src = "MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/declancm/cinnamon.nvim" }, -- ctrl d/u animations
	{ src = "folke/noice.nvim" }, -- yeah
	{ src = "rcarriga/nvim-notify" }, -- noice dependency

	-- git stuff
	{ src = "lewis6991/gitsigns.nvim" },
	{ src = "tpope/vim-fugitive" },

	-- Random
	{ src = "folke/persistence.nvim" },
	{ src = "nvim-lua/plenary.nvim" },
	{ src = "mikavilpas/yazi.nvim" },
	{ src = "goolord/alpha-nvim" },
	{ src = "m4xshen/hardtime.nvim" },
	{ src = "scinac/vim-norm-trainer.nvim" },
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },
}, {
	-- prevent packadd! or packadd like this to allow on_require handler to load plugin spec
	load = function() end,
})

require("lze").load({
	{
		"vim-norm-trainer.nvim",
		cmd = { "NormGame" },
	},
	{
		"hardtime.nvim",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("hardtime").setup({
				max_count = 5,
				disable_mouse = false,
				disabled_filetypes = {
					["nvim-pack"] = true,
					["drop*"] = true,
				},
			})
		end,
	},
	{
		"cinnamon.nvim",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("plugins.cinnamon")
		end,
	},
	{
		"smear-cursor.nvim",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("plugins.smear")
		end,
	},
	{
		"flash.nvim",
		keys = {
    -- stylua: ignore start 
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "r", mode = "o", "x", function() require("flash").remote() end, desc = "Remote Flash" },
    { "S", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
			-- stylua: ignore end
		},
		after = function()
			require("plugins.flash")
			vim.api.nvim_exec_autocmds("User", { pattern = "flashload" })
		end,
	},
	{
		"alpha-nvim",
		after = function()
			require("plugins.alpha")
		end,
	},
	{
		"nvim-notify",
		dep_of = "noice.nvim",
		after = function()
			require("plugins.notify")
		end,
	},
	{
		"lualine.nvim",
		after = function()
			require("plugins.lualine")
		end,
	},
	{
		"showkeys",
		cmd = "ShowkeysToggle",
		keys = {
			{ "<leader>ks", "<cmd>ShowkeysToggle<cr>", desc = "Enable showkeys" },
		},
		after = function()
			require("plugins.showkeys")
		end,
	},
	{
		"noice.nvim",
		dep_of = "lualine.nvim",
		after = function()
			require("plugins.noice")
		end,
	},
	{
		"plenary.nvim",
		dep_of = "yazi.nvim",
	},
	{
		"yazi.nvim",
		cmd = "Yazi",
		keys = {
			{ "\\", "<cmd>Yazi<cr>", desc = "Open Yazi" },
			{ "<leader>\\", "<cmd>Yazi cwd<cr>", desc = "Open Yazi current cwd" },
			{ "<C-w>\\", "<cmd>Yazi toggle<cr>", desc = "Resume Yazi" },
		},
		after = function()
			require("plugins.yazi")
		end,
	},
	{
		"fzf-lua",
		dep_of = "alpha-nvim",
		on_require = { "^fzf-lua" },
		keys = {
			{ "<leader>ir", "<cmd>FzfLua oldfiles<CR>", desc = "Fuzzy find recent files" },
			{ "<leader>if", "<cmd>FzfLua files<CR>", desc = "Fuzzy find files" },
			{ "<leader>ig", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
			{ "<leader>ik", "<cmd>FzfLua keymaps<cr>", desc = "Live grep" },
			{ "<leader>ib", "<cmd>FzfLua buffers<cr>", desc = "Find buffers" },
			{ "<leader>ih", "<cmd>FzfLua help_tags<cr>", desc = "Find help" },
			{ "<leader>isg", "<cmd>FzfLua grep<cr>", desc = "Find strings (grep)" },
			{ "<leader>in", "<cmd>FzfLua profiles<cr>", desc = "Fzf Profiles" },
			{ "<leader>isc", "<cmd>FzfLua grep_cWORD<cr>", desc = "Find Connected Words under cursor" },
		},
		after = function()
			require("plugins.fzflua")
			require("fzf-lua").register_ui_select()
		end,
	},
	----------------------------------------------------------------------------
	-- git stuff
	----------------------------------------------------------------------------
	{
		"gitsigns.nvim",
		dep_of = "vim-fugitive",
	},
	{
		"vim-fugitive",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("plugins.gitstuff")
		end,
	},
	----------------------------------------------------------------------------
	-- treesitter and general code coloring and stuff
	----------------------------------------------------------------------------
	{
		"tree-sitter-manager.nvim",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("plugins.treesitter")
		end,
	},
	{
		"todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("plugins.todo-comments")
		end,
	},
	{
		"nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("plugins.colorizer")
		end,
	},

	{
		"nvim-ts-context-commentstring",
		dep_of = { "tree-sitter-manager.nvim" },
	},
	{
		"nvim-ts-autotag",
		event = "InsertEnter",
		dep_of = { "tree-sitter-manager.nvim" },
		on_require = { "nvim-ts-autotag" },
		after = function()
			-- If you config autotag via a custom lua file, load it here.
			-- Otherwise, if it auto-starts, you can omit the after block.
			require("nvim-ts-autotag").setup({})
		end,
	},
	----------------------------------------------------------------------------
	-- COMPLETION & LSP (Load only when interacting with code)
	----------------------------------------------------------------------------
	{
		"nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dep_of = { "lazydev.nvim" },
		after = function()
			require("lsp.lspconfig")
		end,
	},
	{
		"blink.cmp",
		dep_of = "nvim-lspconfig",
		event = "InsertEnter",
		after = function()
			require("plugins.blink")
		end,
	},
	{
		"blink.lib",
		dep_of = { "blink.cmp" },
	},
	{
		"LuaSnip",
		dep_of = { "blink.cmp" },
	},
	{
		"friendly-snippets",
		dep_of = { "blink.cmp" },
	},
	{
		"conform.nvim",
		event = "BufWritePre",
		after = function()
			require("lsp.formatting")
		end,
	},
	{
		"nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("lsp.linting")
		end,
	},
	{
		"nvim-ufo",
		event = "BufReadPost",
		after = function()
			require("plugins.nvim-ufo")
		end,
	},
	{
		"nvim-autopairs",
		event = "InsertEnter",
		after = function()
			require("plugins.auto-pairs")
		end,
	},
	{
		"persistence.nvim",
		dep_of = "alpha-nvim",
		after = function()
			require("plugins.persistence")
		end,
	},
	{
		"render-markdown.nvim",
		ft = "markdown",
		after = function()
			require("plugins.render-markdown")
		end,
	},
	{
		"lazydev.nvim",
		ft = "lua",
		after = function()
			require("plugins.lazydev")
		end,
	},
})
