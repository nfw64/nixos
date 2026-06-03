-- 1. Define Option Tables
local bufferline_opts = {}

-- 2. Define Keymaps Function
local function setup_bufferline_keymaps()
	local maps = {
		{ "<leader><tab>p", "<Cmd>BufferLineTogglePin<CR>", "Toggle Pin" },
		{ "<leader><tab>P", "<Cmd>BufferLineGroupClose ungrouped<CR>", "Delete Non-Pinned Buffers" },
		{ "<leader><tab>l", "<Cmd>BufferLineCloseRight<CR>", "Delete Buffers to the Right" },
		{ "<leader><tab>h", "<Cmd>BufferLineCloseLeft<CR>", "Delete Buffers to the Left" },
		{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", "Prev Buffer" },
		{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", "Next Buffer" },
		{ "[b", "<cmd>BufferLineCyclePrev<cr>", "Prev Buffer" },
		{ "]b", "<cmd>BufferLineCycleNext<cr>", "Next Buffer" },
		{ "[B", "<cmd>BufferLineMovePrev<cr>", "Move buffer prev" },
		{ "]B", "<cmd>BufferLineMoveNext<cr>", "Move buffer next" },
		{ "<leader><tab>j", "<cmd>BufferLinePick<cr>", "Pick Buffer" },
		{ "<leader><tab>d", "<cmd>:bd<CR>", "Delete or Close Buffer (Confirm)" },
	}
	for _, map in ipairs(maps) do
		vim.keymap.set("n", map[1], map[2], { desc = map[3], silent = true })
	end
end
setup_bufferline_keymaps()

local bufferline = require("bufferline")
bufferline.setup({
	options = {
		diagnostics = "nvim_lsp",
		always_show_bufferline = false,
		offsets = {
			{ filetype = "neo-tree", text = "Neo-tree", highlight = "Directory", text_align = "left" },
		},
		style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.minimal,
		themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
		indicator = {
			icon = "▎", -- this should be omitted if indicator style is not 'icon'
			style = "underline",
		},
		color_icons = true,
		show_close_icon = false,
		separator_style = "slant",
		highlights = {
			fill = {
				attribute = "bg",
				highlight = "Pmenu",
			},
		},
	},
})

vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
	callback = function()
		vim.schedule(function()
			pcall(nvim_bufferline)
		end)
	end,
})

_G.deleted_buffers_history = _G.deleted_buffers_history or {}

vim.api.nvim_create_autocmd("BufDelete", {
	group = vim.api.nvim_create_augroup("BufferUndoTracker", { clear = true }),
	callback = function(args)
		local buf_name = vim.api.nvim_buf_get_name(args.buf)
		local buf_type = vim.bo[args.buf].buftype

		if buf_name ~= "" and buf_type == "" then
			table.insert(_G.deleted_buffers_history, {
				path = buf_name,
				time = os.clock(),
			})
			if #_G.deleted_buffers_history > 30 then
				table.remove(_G.deleted_buffers_history, 1)
			end
		end
	end,
})

vim.keymap.set("n", "<leader><tab>u", function()
	if #_G.deleted_buffers_history == 0 then
		print("No closed buffers to undo!")
		return
	end

	local last_item = table.remove(_G.deleted_buffers_history)
	vim.cmd("badd " .. vim.fn.fnameescape(last_item.path))
	local count = 1

	while #_G.deleted_buffers_history > 0 do
		local next_item = _G.deleted_buffers_history[#_G.deleted_buffers_history]
		if math.abs(last_item.time - next_item.time) < 0.05 then
			table.remove(_G.deleted_buffers_history)
			vim.cmd("badd " .. vim.fn.fnameescape(next_item.path))
			count = count + 1
		else
			break
		end
	end

	print("Restored " .. count .. " buffer(s)!")
end, { desc = "Undo last buffer closure" })
