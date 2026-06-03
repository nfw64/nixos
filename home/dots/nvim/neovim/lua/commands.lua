-- Custom packer commands

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

_G.inspect_any = function(item)
	local item_type = type(item)

	if item_type == "table" then
		vim.print(item)
		return
	end

	if item_type == "function" then
		local info = debug.getinfo(item, "S")
		if info.what == "C" then
			print("Function is written in C (Binary code)")
		elseif not info.source or info.source:sub(1, 1) ~= "@" then
			print("Function is anonymous or defined inline")
		else
			local filepath = info.source:sub(2)
			local lines = vim.fn.readfile(filepath)
			local func_lines = {}
			for i = info.linedefined, info.lastlinedefined do
				table.insert(func_lines, lines[i])
			end
			print(table.concat(func_lines, "\n"))
		end
		return
	end

	print(tostring(item))
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

-- NOTE: Packer list active and inactive plugins

vim.api.nvim_create_user_command("Pcg", function(opts)
	-- Parse arguements if provided
	local names = nil
	if opts.args ~= "" then
		names = vim.split(opts.args, "%s+", { trimempty = true })
	end

	local raw_data = vim.pack.get(names)
	if not raw_data or vim.tbl_isempty(raw_data) then
		vim.notify("No plugins found in vim.pack.", vim.log.levels.WARN)
		return
	end

	-- Parse data
	local plugin_list = {}
	for _, item in ipairs(raw_data) do
		local extracted_name = (item.spec and item.spec.name) or "Unknown Plugin"
		local version_display = "No Version"
		if item.tags and item.tags[1] then
			version_display = item.tags[1]
		elseif item.rev then
			version_display = item.rev:sub(1, 7)
		end
		table.insert(plugin_list, {
			name = extracted_name,
			is_active = item.active or false,
			version = version_display,
		})
	end

	table.sort(plugin_list, function(a, b)
		if a.is_active ~= b.is_active then
			return not a.is_active and b.is_active
		end
		return a.name < b.name
	end)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_command("split")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(win, buf)
	vim.bo[buf].filetype = "vimpack"
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"

	local lines = {
		"         === Downloaded Plugins ===",
	}

	local highlights = {}

	for _, plugin in ipairs(plugin_list) do
		local status_str = plugin.is_active and "●" or "○"

		local line_text = string.format(" %s  %-35s (%s)", status_str, plugin.name, plugin.version)
		table.insert(lines, line_text)

		table.insert(highlights, {
			line_idx = #lines - 1,
			is_active = plugin.is_active,
			line_len = #line_text,
		})
	end

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	local ns = vim.api.nvim_create_namespace("vimpack_status_colors")
	vim.api.nvim_buf_set_extmark(buf, ns, 0, 0, { end_col = #lines[1], hl_group = "Title" })
	vim.api.nvim_buf_set_extmark(buf, ns, 1, 0, { end_col = #lines[2], hl_group = "Comment" })

	for _, hl in ipairs(highlights) do
		local active_col_end = math.min(11, hl.line_len)
		local inactive_col_end = math.min(13, hl.line_len)

		if hl.is_active then
			vim.api.nvim_buf_set_extmark(
				buf,
				ns,
				hl.line_idx,
				1,
				{ end_col = active_col_end, hl_group = "DiagnosticSignOk" }
			)
		else
			vim.api.nvim_buf_set_extmark(buf, ns, hl.line_idx, 1, { end_col = inactive_col_end, hl_group = "Comment" })
		end
	end
	vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true, nowait = true })
end, { desc = "Get Plugin list status dashboard", nargs = "*" })
