-- Initialize the modern lightweight native parser installer
local ts_manager = require("tree-sitter-manager")

-- stylua: ignore 
local ensure_installed = {
    "dockerfile", "gitignore", "query", "vimdoc", "c", "java", "rust", "ron",
    "json", "javascript", "typescript", "tsx", "go", "yaml", "html", "css", "python", "http",
    "prisma", "markdown", "markdown_inline", "svelte", "graphql", "bash", "lua", "vim",
}

ts_manager.setup({
	ensure_installed = ensure_installed,
	auto_install = true,
	highlight = true,
})

-- Native Tree-Sitter Buffering & Custom Indentation Hook
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(args)
		local buf = args.buf
		local ft = vim.bo[buf].filetype

		-- Native Neovim 0.12 fallback indentation mechanics
		if ft ~= "yaml" and ft ~= "markdown" then
			-- Replaces old plugin 'indentexpr()' abstract pointer
			vim.bo[buf].indentexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.bo[buf].smartindent = false
			vim.bo[buf].cindent = false
		end

		local lang = vim.treesitter.language.get_lang(ft) or ft

		-- Safely search and map internal queries for the current workspace language
		local has_parser, _ = pcall(vim.treesitter.language.add, lang)
		if not has_parser then
			return
		end

		-- Spin up native runtime engine for the active code layer
		pcall(vim.treesitter.start, buf, lang)
	end,
})

-- Independent nvim-ts-autotag setup (Kept clean and untouched)
require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true,
		enable_rename = true,
		enable_close_on_slash = false,
	},
	per_filetype = {
		["html"] = {
			enable_close = true,
		},
		["typescriptreact"] = {
			enable_close = true,
		},
	},
})
