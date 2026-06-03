require("cinnamon").setup({
	keymaps = {
		basic = false,
		extra = false,
	},
	options = {
		-- The scrolling mode
		-- `cursor`: animate cursor and window scrolling for any movement
		-- `window`: animate window scrolling ONLY when the cursor moves out of view
		mode = "cursor",

		count_only = false,

		-- Delay between each movement step (in ms)
		delay = 5,

		max_delta = {
			-- Maximum distance for line movements before scroll
			-- animation is skipped. Set to `false` to disable
			line = false,
			-- Maximum distance for column movements before scroll
			-- animation is skipped. Set to `false` to disable
			column = false,
			-- Maximum duration for a movement (in ms). Automatically scales the
			-- delay and step size
			time = 1000,
		},
	},
})

-- Centered scrolling:
vim.keymap.set("n", "<C-u>", function()
	require("cinnamon").scroll("<C-u>zz")
end)
vim.keymap.set("n", "<C-d>", function()
	require("cinnamon").scroll("<C-d>zz")
end)

-- LSP:
vim.keymap.set("n", "gd", function()
	require("cinnamon").scroll(vim.lsp.buf.definition)
end)
vim.keymap.set("n", "gD", function()
	require("cinnamon").scroll(vim.lsp.buf.declaration)
end)

-- Flash.nvim integration:
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "flashload",
-- 	callback = function()
-- 		print("hm")
-- 		require("flash").setup({
-- 			action = function(match, state)
-- 				require("cinnamon").scroll(function()
-- 					require("flash.jump").jump(match, state)
-- 					require("flash.jump").on_jump(state)
-- 				end)
-- 			end,
-- 		})
-- 	end,
-- })
