-- NOTE: LSP Custom Keybinds
-- NOTE: LSP Keybinds
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings
		local opts = { buffer = ev.buf, silent = true }
		-- Keymaps
		-------------------------------------------------------------------------------------
		opts.desc = "Show LSP references"
		vim.keymap.set("n", "<leader>lr", "<cmd>FzfLua lsp_references<CR>", opts)

		opts.desc = "Go to declaration"
		vim.keymap.set("n", "<leader>lK", vim.lsp.buf.declaration, opts)

		opts.desc = "Show LSP definitions"
		vim.keymap.set("n", "<leader>ldj", "<cmd>FzfLua lsp_definitions<CR>", opts)

		opts.desc = "Show LSP implementations"
		vim.keymap.set("n", "<leader>li", "<cmd>FzfLua lsp_implementations<CR>", opts)

		opts.desc = "Show LSP type definitions"
		vim.keymap.set("n", "<leader>ldk", "<cmd>Telescope lsp_type_definitions<CR>", opts)

		opts.desc = "Run LSP CodeLens"
		vim.keymap.set("n", "<leader>lx", vim.lsp.codelens.run, opts)

		opts.desc = "Smart rename (LSP)"
		vim.keymap.set("n", "<leader>lcr", vim.lsp.buf.rename, opts)

		opts.desc = "Show buffer diagnostics"
		vim.keymap.set("n", "<leader>lb", "<cmd>FzfLua diagnostics_document<CR>", opts)

		------------------------------------------------------------------------------------

		opts.desc = "See available code actions"
		vim.keymap.set({ "n", "v" }, "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, opts)

		opts.desc = "Signature Help"
		vim.keymap.set("i", "<A-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)

		opts.desc = "Show documentation for what is under cursor"
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	end,
})

local opts = { silent = true }
opts.desc = "Restart LSP"
vim.keymap.set("n", "<leader>lmr", "<cmd>lsp restart<CR>", opts)
opts.desc = "Stop LSP"
vim.keymap.set("n", "<leader>lms", "<cmd>lsp stop<CR>", opts)
opts.desc = "Disable LSP"
vim.keymap.set("n", "<leader>lmd", "<cmd>lsp disable<CR>", opts)
opts.desc = "Enable LSP"
vim.keymap.set("n", "<leader>lme", "<cmd>lsp enable<CR>", opts)

-- NOTE: Diagnostic Setup
-- Define sign icons for each severity
local signs = {
	[vim.diagnostic.severity.ERROR] = " ",
	[vim.diagnostic.severity.WARN] = " ",
	[vim.diagnostic.severity.HINT] = "󰠠 ",
	[vim.diagnostic.severity.INFO] = " ",
}
-- update diagnostic config function
vim.diagnostic.config({
	signs = { text = signs },
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	float = {
		focusable = false,
		style = "minimal",
		border = "single",
		source = true,
	},
})

-- toggle for virtual text
vim.keymap.set("n", "<leader>lmx", function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current })
end, { desc = "Toggle LSP virtual text" })

-- NOTE: Setup servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- blink cmp
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

-- Global LSP settings (applied to all servers)
vim.lsp.config("*", {
	capabilities = capabilities,
})

-- Configure and enable LSP servers
-- lua_ls
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			completion = {
				callSnippet = "Replace",
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

-- css
vim.lsp.config("cssls", {
	filetypes = { "css", "scss", "less" },
	init_options = { provideFormatter = true },
	single_file_support = true,
	settings = {
		css = {
			lint = {
				unknownAtRules = "ignore",
			},
			validate = true,
		},
		scss = {
			lint = {
				unknownAtRules = "ignore",
			},
			validate = true,
		},
		less = {
			lint = {
				unknownAtRules = "ignore",
			},
			validate = true,
		},
	},
})

vim.lsp.config("qml-language-server", {
	cmd = { "qml-language-server" },
	filetypes = { "qml" },
	root_markers = { { "qmldir", "shell.qml" } },
})

vim.lsp.config("bash-language-server", {
	cmd = { "bash-language-servre" },
	filetypes = { "sh", "bash" },
	root_markers = { ".git" },
})

vim.lsp.config("nil_ls", {
	cmd = { "nil" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
	settings = {
		["nil"] = {
			nix = {
				autoArchive = false,
				flake = {
					autoEvalInputs = true,
				},
			},
		},
	},
})

vim.lsp.enable({
	"lua_ls",
	"qml-language-server",
	"nil_ls",
	"bashls",
})
