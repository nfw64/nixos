require("oil").setup({
	default_file_explorer = true, -- start up nvim with oil instead of netrw
	columns = {},
	keymaps = {
		["<C-h>"] = false,
		["<C-l>"] = false,
		["<C-c>"] = false, -- prevent from closing Oil as <C-c> is esc key
		["<C-s>"] = false,
		["<C-r>"] = "actions.refresh",
		["<M-h>"] = "actions.select_split",
		["<S-h>"] = "actions.parent",
		["<S-l>"] = "actions.select",
		["`"] = function()
			require("oil.actions").cd.callback()
			require("oil").close()
		end,
		["q"] = "actions.close",
	},

	delete_to_trash = true,
	view_options = {
		show_hidden = true,
	},
	skip_confirm_for_simple_edits = true,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.opt_local.cursorline = true
	end,
})
