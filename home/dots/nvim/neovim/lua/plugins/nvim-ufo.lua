require("ufo").setup({
    -- treesitter not required
    -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
    -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`-
    provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
    end,
    open_fold_hl_timeout = 0, -- Disable highlight timeout after opening
})

vim.o.foldenable = true
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- za to fold at cursor location is already enabled
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
