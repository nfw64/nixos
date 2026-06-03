local noice = require("noice")

noice.setup({
	presets = {
		bottom_search = true,
		long_message_to_split = true,
		lsp_doc_border = true,
	},
	notify = {
		enabled = true,
		border = { style = "single" },
	},
	messages = {
		enabled = true,
		border = { style = "single" },
		view = "notify",
		view_error = "notify",
		view_warn = "mini",
		view_history = "mini",
		view_search = false,
	},
	health = { checker = false },
	lsp = {
		progress = { enabled = true },
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
		hover = { enabled = true, silent = true },
		signature = { enabled = true },
	},
	views = {
		split = {
			win_options = { wrap = false },
			close = { keys = { "q", "<CR>", "<Esc>" } },
			size = 10,
			border = { style = "single" },
		},
		confirm = {
			backend = "popup",
			relative = "editor",
			position = {
				row = "50%",
				col = "50%",
			},
			border = { style = "single" },
		},
		cmdline_popup = {
			border = {
				style = "single",
				padding = { 0, 1 },
			},
			position = {
				row = "50%",
				col = "50%",
			},
			size = {
				width = 40,
				height = "auto",
			},
		},
		popupmenu = {
			relative = "editor",
			backend = "cmp",
			position = {
				row = "70%",
				col = "45%",
			},
			size = {
				width = 30,
				height = 10,
			},
			border = {
				style = "single",
				padding = { 0, 1 },
			},
			win_options = {
				winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
			},
		},
	},

	routes = {
		{
			view = "notify",
			filter = { event = "msg_showmode" },
		},
		{
			filter = {
				event = "msg_show",
				any = { { min_height = 5 }, { min_width = 200 } },
				["not"] = {
					kind = { "confirm", "confirm_sub", "return_prompt", "quickfix", "search_count" },
				},
				blocking = false,
			},
			view = "messages",
			opts = { stop = true },
		},
		{
			filter = {
				event = "msg_show",
				kind = "",
				find = "written",
			},
			opts = { skip = true },
		},
		{
			filter = {
				event = "msg_show",
				any = {
					{ find = "; after #%d+" },
					{ find = "; before #%d+" },
					{ find = "fewer lines" },
				},
			},
			view = "mini",
		},
	},
})

vim.keymap.set("n", "<leader>nl", function()
	require("noice").cmd("history")
end, { desc = "Noice History" })

vim.keymap.set("n", "<leader>na", function()
	require("noice").cmd("all")
end, { desc = "Noice All" })

vim.keymap.set("n", "<leader>ne", function()
	require("noice").cmd("errors")
end, { desc = "Noice Errors" })

vim.keymap.set("n", "<leader>nda", function()
	require("noice").cmd("dismiss")
end, { desc = "Dismiss All" })

vim.keymap.set("n", "<leader>np", function()
	require("noice").cmd("pick")
end, { desc = "Noice Picker (Telescope/FzfLua)" })

vim.keymap.set({ "i", "n", "s" }, "<c-f>", function()
	if not require("noice.lsp").scroll(4) then
		return "<c-f>"
	end
end, { silent = true, expr = true, desc = "Scroll Forward" })

vim.keymap.set({ "i", "n", "s" }, "<c-b>", function()
	if not require("noice.lsp").scroll(-4) then
		return "<c-b>"
	end
end, { silent = true, expr = true, desc = "Scroll Backward" })
