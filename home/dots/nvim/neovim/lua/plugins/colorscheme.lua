require("generated")
vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE" })
vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE" })
local function source_matugen()
	-- Update this with the location of your output file
	local matugen_path = os.getenv("HOME") .. "/.config/nvim/lua/generated.lua" -- dofile doesn't expand $HOME or ~

	local file, err = io.open(matugen_path, "r")
	-- If the matugen file does not exist (yet or at all), we must initialize a color scheme ourselves
	if err ~= nil then
		vim.cmd("colorscheme catppuccin")

		vim.print(
			"A matugen style file was not found, but that's okay! The colorscheme will dynamically change if matugen runs!"
		)
	else
		dofile(matugen_path)
		io.close(file)
	end
end

local function auxiliary_function()
	source_matugen()
	dofile(os.getenv("HOME") .. "/.config/nvim/lua/plugins/lualine.lua")
	require("lualine").refresh({
		scope = "global",
		place = { "statusline" },
	})
	vim.api.nvim_set_hl(0, "Comment", { italic = true })
end

-- Register an autocmd to listen for matugen updates
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = auxiliary_function,
})
