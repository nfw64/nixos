-- NOTE: mini.indentscope
require("mini.indentscope").setup({
	symbol = "│",
})

vim.g.miniindentscope_disable = false
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "alpha", "term", "dropbar_menu", "dashboard", "help", "trouble", "lazy", "mason" },
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})
vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.b.miniindentscope_disable = true
	end,
})

-- NOTE:  mini.cursorwords
require("mini.cursorword").setup({
	delay = 100,
})

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function()
		vim.b.minicursorword_disable = true
	end,
})

-- NOTE: mini.surround
require("mini.surround").setup({
	custom_surroundings = nil,
	highlight_duration = 300,
	-- INFO:
	-- saiw surround with no whitespace
	-- saw surround with whitespace
	mappings = {
		add = "zsa", -- Add surrounding in Normal and Visual modes
		delete = "zsd", -- Delete surrounding
		find = "", -- Find surrounding (to the right)
		find_left = "", -- Find surrounding (to the left)
		highlight = "zsh", -- Highlight surrounding
		replace = "zsr", -- Replace surrounding
		update_n_lines = "zsn", -- Update `n_lines`
	},
})

-- NOTE: mini.ai
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
	once = true,
	callback = function()
		require("mini.ai").setup()

		local ai = require("mini.ai")
		local opts = {
			n_lines = 500,
			custom_textobjects = {
				o = ai.gen_spec.treesitter({ -- code block
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
				t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
				d = { "%f[%d]%d+" }, -- digits
				e = { -- Word with case
					{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
					"^().*()$",
				},
				g = function()
					local buf = vim.api.nvim_get_current_buf()
					return {
						{ line_start = 1, line_end = vim.api.nvim_buf_line_count(buf), col_start = 1, col_end = 1 },
					}
				end,
				u = ai.gen_spec.function_call(),
				U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
			},
		}

		ai.setup(opts)
		local has_wk, wk = pcall(require, "which-key")
		if has_wk then
			vim.schedule(function()
				local objects = {
					{ " ", desc = "whitespace" },
					{ '"', desc = '" string' },
					{ "'", desc = "' string" },
					{ "(", desc = "() block" },
					{ ")", desc = "() block with ws" },
					{ "<", desc = "<> block" },
					{ ">", desc = "<> block with ws" },
					{ "?", desc = "user prompt" },
					{ "U", desc = "use/call without dot" },
					{ "[", desc = "[] block" },
					{ "]", desc = "[] block with ws" },
					{ "_", desc = "underscore" },
					{ "`", desc = "` string" },
					{ "a", desc = "argument" },
					{ "b", desc = "() block" },
					{ "c", desc = "class" },
					{ "d", desc = "digit" },
					{ "e", desc = "word case" },
					{ "f", desc = "function" },
					{ "g", desc = "buffer" },
					{ "o", desc = "code block" },
					{ "q", desc = "quote `\"'" },
					{ "t", desc = "tag" },
					{ "u", desc = "use/call" },
					{ "{", desc = "{} block" },
					{ "}", desc = "{} block with ws" },
				}

				local mappings = { mode = { "o", "x" } }
				for _, prefix in ipairs({ "a", "i" }) do
					for _, obj in ipairs(objects) do
						table.insert(mappings, { prefix .. obj[1], desc = obj.desc })
					end
				end
				wk.add(mappings)
			end)
		end
	end,
})

-- NOTE: mini.trailspace (get rid of whitespace)
require("mini.trailspace").setup({
	only_in_normal_buffers = true,
})
vim.keymap.set("n", "<leader>cw", function()
	require("mini.trailspace").trim()
end, { desc = "Erase Whitespace" })
-- Ensure highlight never reappears by removing it on CursorMoved
vim.api.nvim_create_autocmd("CursorMoved", {
	pattern = "*",
	callback = function()
		require("mini.trailspace").unhighlight()
	end,
})

-- NOTE: mini.splitjoin (split & join)
require("mini.splitjoin").setup({
	mappings = { toggle = "" }, -- Disable default mapping
})
vim.keymap.set({ "n", "x" }, "Sj", function()
	require("mini.splitjoin").join()
end, { desc = "Join arguments" })
vim.keymap.set({ "n", "x" }, "Sk", function()
	require("mini.splitjoin").split()
end, { desc = "Split arguments" })

-- NOTE: mini.comment
require("mini.comment").setup({
	options = {
		custom_commentstring = function()
			return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
		end,
	},
})

-- NOTE: mini.files (file explorer that works great alongside oil)
local mini_files = require("mini.files")
mini_files.setup({
	mappings = {
		go_in = "<CR>",
		go_in_plus = "L",
		go_out = "_",
		go_out_plus = "H",
	},
})
vim.keymap.set("n", "<leader>ef", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" })
vim.keymap.set("n", "<leader>ee", function()
	mini_files.open(vim.api.nvim_buf_get_name(0), false)
	mini_files.reveal_cwd()
end, { desc = "Toggle into currently opened file" })

-- auto close picker after buffer opened
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	group = vim.api.nvim_create_augroup("MiniFilesCloseOnSelect", { clear = true }),
	callback = function(args)
		local buf_id = args.data.buf_id

		-- Map the standard edit/open key (CR / Enter) to open and close
		vim.keymap.set("n", "<CR>", function()
			-- 1. Perform the default open action
			MiniFiles.go_in({})
			-- 2. Immediately close the file explorer
			MiniFiles.close()
		end, { buffer = buf_id, desc = "Open file and close menu" })
	end,
})

-- NOTE: mini.operators
require("mini.operators").setup({
	evaluate = {
		prefix = "g=",
	},
	exchange = { prefix = "ga" },
	multiply = { prefix = "gm" },
	replace = { prefix = "gr" },
	sort = { prefix = "gz" },
})
