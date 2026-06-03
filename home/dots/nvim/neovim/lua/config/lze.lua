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
	{ src = "nvim-telescope/telescope.nvim", branch = "master" },
	{ src = "nvim-telescope/telescope-ui-select.nvim" },
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
	{ src = "NvChad/nvim-colorizer.lua" },
	{ src = "MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/declancm/cinnamon.nvim" },
	{ src = "folke/noice.nvim" },
	{ src = "akinsho/bufferline.nvim" },

	-- git stuff
	{ src = "NeogitOrg/neogit" },
	{ src = "lewis6991/gitsigns.nvim" },
	{ src = "ThePrimeagen/git-worktree.nvim" },
	{ src = "tpope/vim-fugitive" },
	{ src = "vimpostor/vim-tpipeline" },

	-- Random
	{ src = "folke/persistence.nvim" },
	{ src = "stevearc/oil.nvim" },
	{ src = "goolord/alpha-nvim" },
	{ src = "m4xshen/hardtime.nvim" },
}, {
	-- prevent packadd! or packadd like this to allow on_require handler to load plugin spec
	load = function() end,
})

require("lze").load({
	{
		"cinnamon.nvim",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("plugins.cinnamon")
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
		"vim-tpipeline",
	},
	{
		"hardtime.nvim",
		event = { "BufReadPre", "BufNewFile" },
		after = function()
			require("hardtime").setup({
				max_count = 5,
				disabled_filetypes = {
					["nvim-pack"] = false, -- Enable Hardtime in filetype starting with dapui
				},
			})
		end,
	},
	{
		"alpha-nvim",
		after = function()
			require("plugins.alpha")
		end,
	},
	{
		"noice.nvim",
		after = function()
			require("plugins.noice")
		end,
	},
	{
		"bufferline.nvim",
		after = function()
			require("plugins.bufferline")
		end,
	},
	{
		"oil.nvim",
		cmd = "Oil",
		keys = {
			{ "\\", "<cmd>Oil<cr>", desc = "Open Oil" },
			{ "<leader>\\", "<cmd>Oil --float<cr>", desc = "Open Oil float" },
		},
		after = function()
			require("plugins.oil")
		end,
	},
	{
		"telescope-ui-select.nvim",
		dep_of = "telescope.nvim",
	},
	{
		"telescope.nvim",
		-- Tell lze that requiring "telescope" should pull this plugin out of lazy state
		on_require = { "^telescope" },
		event = {
			{
				event = "CmdUndefined",
				pattern = "Telescope*",
				-- Returning true immediately triggers `lze` to run the 'load' function
				callback = function()
					return true
				end,
			},
		},
		keys = {
			{ "<leader>ir", "<cmd>Telescope oldfiles<CR>", desc = "Fuzzy find recent files" },
			{ "<leader>if", "<cmd>Telescope find_files<CR>", desc = "Fuzzy find files" },
			{ "<leader>ig", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>ib", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
			{ "<leader>ih", "<cmd>Telescope help_tags<cr>", desc = "Find help" },
			{ "<leader>isg", "<cmd>Telescope grep_string<cr>", desc = "Find strings (grep)" },
			{ "<leader>nn", "<cmd>Telescope notify<cr>", desc = "Find strings (grep)" },
			{
				"<leader>isc",
				function()
					local builtin = require("telescope.builtin")
					local word = vim.fn.expand("<cWORD>")
					builtin.grep_string({ search = word })
				end,
				desc = "Find Connected Words under cursor",
			},
		},
		after = function()
			require("plugins.telescope")
		end,
	},
	----------------------------------------------------------------------------
	-- git stuff
	----------------------------------------------------------------------------
	{
		"gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dep_of = { "telescope.nvim" },
		after = function()
			-- Require the file and execute ONLY the gitsigns config safely
			local gitstuff = require("plugins.gitstuff")
			gitstuff.setup_gitsigns()
		end,
	},
	{
		"vim-fugitive",
		cmd = { "Git", "G" },
		after = function()
			local gitstuff = require("plugins.gitstuff")
			gitstuff.setup_fugitive()
		end,
	},
	{
		"git-worktree.nvim",
		on_require = { "telescope.nvim" },
		cmd = { "Git", "G" },
		-- Since it depends on telescope, load it when telescope loads or keybinds are pressed
		after = function()
			local gitstuff = require("plugins.gitstuff")
			gitstuff.setup_worktree()
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
			require("plugins.lspconfig")
		end,
	},
	{
		"blink.cmp",
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
			require("plugins.formatting")
		end,
	},
	{
		"nvim-lint",
		event = { "BufReadPost", "BufNewFile" },
		after = function()
			require("plugins.linting")
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
