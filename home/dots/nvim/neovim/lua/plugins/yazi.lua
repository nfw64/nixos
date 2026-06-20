local ok, base16 = pcall(require, "base16-colorscheme")
local colors = ok and base16.colors or {}

vim.g.loaded_netrwPlugin = 1
require("yazi").setup({
	open_for_directories = true,
	change_neovim_cwd_on_close = false,
	yazi_floating_window_border = "single",
	highlight_groups = {
		hovered_buffer = { fg = colors.base00 },
		hovered_buffer_in_same_directory = { fg = colors.base00 },
	},
	keymaps = {
		show_help = "<f1>",
		open_file_in_vertical_split = "<c-v>",
		open_file_in_horizontal_split = "<c-b>",
		open_file_in_tab = false,
		grep_in_directory = "<c-s>",
		replace_in_directory = false,
		cycle_open_buffers = "<tab>",
		copy_relative_path_to_selected_files = "<c-y>",
		send_to_quickfix_list = "<c-x>",
		change_working_directory = "'",
		open_and_pick_window = false,
	},
	integrations = {
		grep_in_directory = function(directory)
			require("fzf-lua").live_grep({ cwd = directory })
		end,

		grep_in_selected_files = function(selected_files)
			require("fzf-lua").live_grep({ search_dirs = selected_files })
		end,
	},
})
