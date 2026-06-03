-- Automatically replaces 'stylua' with '-- stylua: ignore' upon pressing space/enter
vim.keymap.set("ia", "fmts", "-- stylua: ignore start", { buffer = true })
vim.keymap.set("ia", "fmti", "-- stylua: ignore", { buffer = true })
vim.keymap.set("ia", "fmte", "-- stylua: ignore end", { buffer = true })
