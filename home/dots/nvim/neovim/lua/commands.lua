local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	-- Calculate the position to center the window
	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	-- Create a buffer
	local buf = nil
	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
	end

	-- Define window configuration
	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal", -- No borders or extra UI elements
		border = "single",
	}
	local win = vim.api.nvim_open_win(buf, true, win_config)

	return { buf = buf, win = win }
end

local toggle_terminal = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating = create_floating_window({ buf = state.floating.buf })
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.terminal()
			-- 2. Completely hide lualine
			local status_lualine, lualine = pcall(require, "lualine")
			if status_lualine then
				lualine.hide({ place = { "statusline", "tabline", "winbar" } })
			end
		end
		vim.cmd("normal i")
	else
		vim.api.nvim_win_hide(state.floating.win)
		local status_lualine, lualine = pcall(require, "lualine")
		if status_lualine then
			lualine.hide({ unhide = true })
		end
	end
end

vim.api.nvim_create_user_command("Floatterm", toggle_terminal, {})

vim.api.nvim_create_autocmd("BufLeave", {
	desc = "Wipe out empty, nameless scratch buffers left by plugins",
	callback = function(args)
		-- Check if the buffer is valid and loaded
		if vim.api.nvim_buf_is_valid(args.buf) and vim.api.nvim_buf_is_loaded(args.buf) then
			local name = vim.api.nvim_buf_get_name(args.buf)
			local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })
			local modified = vim.api.nvim_get_option_value("modified", { buf = args.buf })

			-- If it has no name, isn't a special terminal/prompt, and isn't modified, kill it
			if name == "" and buftype == "" and not modified then
				vim.api.nvim_buf_delete(args.buf, { force = true })
			end
		end
	end,
})

_G.PckAdd = function(plugins, opts)
	for _, plugin in ipairs(plugins) do
		if not plugin.src:match("^https?://") then
			if plugin.src:match("^github%.com/") then
				plugin.src = "https://" .. plugin.src
			else
				plugin.src = "https://github.com/" .. plugin.src
			end
			if not plugin.src:match("%.git$") then
				plugin.src = plugin.src .. ".git"
			end
		end
	end

	pcall(vim.pack.add, plugins, opts)
end

-- NOTE: pack add
vim.api.nvim_create_user_command("Pca", function(opts)
	local expanded_args = {}
	for _, arg in ipairs(opts.fargs) do
		-- If it doesn't start with http, assume it's a short github path
		if not arg:match("^https?://") then
			table.insert(expanded_args, "https://github.com" .. arg .. ".git")
		else
			table.insert(expanded_args, arg)
		end
	end

	-- Pass the expanded list or single string safely
	pcall(vim.pack.add, expanded_args)
end, { nargs = "+", desc = "Add plugins (PackAdd user/repo)" })

vim.api.nvim_create_user_command("Pct", function(opts)
	-- 1. Parse individual space-separated plugin names if provided
	local names = nil
	if opts.args ~= "" then
		names = vim.split(opts.args, "%s+", { trimempty = true })
	end

	-- 2. Safely query vim.pack.get()
	-- { fetch = true } can optionally be passed as a second parameter to query git upstream
	local plugin_data = vim.pack.get(names)

	-- 3. Print the result clearly to the screen using Neovim's inspector
	print(vim.inspect(plugin_data))
end, { desc = "Get Plugin list", nargs = "*" })

--:packupdate :packupdate! :packdel :packdel! now supported in 0.13 nightly as of May 17
-- NOTE: pack delete
vim.api.nvim_create_user_command("Pcd", function(opts)
	vim.pack.del(opts.fargs)
end, { nargs = "+", desc = "Delete plugins (:PackDel plugin1 plugin2)" })

-- NOTE: pack update
vim.api.nvim_create_user_command("Pcu", function(opts)
	if opts.args ~= "" then
		-- update specific plugins
		local plugins = vim.split(opts.args, "%s+", { trimempty = true })
		vim.pack.update(plugins)
	else
		-- update all
		vim.pack.update()
	end
end, { desc = "Update all plugins or specific ones", nargs = "*" })

-- NOTE: pack nonactive - show all non active plugins on disk but removed from pack.lua
vim.api.nvim_create_user_command("Pcc", function()
	local non_active = vim.iter(vim.pack.get())
		:filter(function(x)
			return not x.active
		end)
		:map(function(x)
			return x.spec.name
		end)
		:totable()

	if #non_active == 0 then
		vim.notify("No non-active plugins found!", vim.log.levels.INFO)
		return
	end

	print(" ")
	vim.print("Non-active plugins :")
	for _, name in ipairs(non_active) do
		print(name)
	end

	print(" ")

	local choice = vim.fn.confirm(
		"Delete ALL non-active plugins from disk?",
		"&Yes\n&No",
		2 -- default = No
	)

	if choice == 1 then
		vim.pack.del(non_active)
		vim.notify("Deleted " .. #non_active .. " non-active plugin(s)", vim.log.levels.INFO)
		print("Non-active plugins deleted!")
		vim.api.nvim_exec_autocmds("User", { pattern = "PackChanged" })
	else
		vim.notify("Cancelled. No plugins were deleted!", vim.log.levels.INFO)
	end
end, { desc = "List non active plugins and select to delete" })
