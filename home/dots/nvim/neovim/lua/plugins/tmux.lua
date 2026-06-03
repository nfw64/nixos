
local navigator_keys = {
  ["<c-h>"] = "TmuxNavigateLeft",
  ["<c-j>"] = "TmuxNavigateDown",
  ["<c-k>"] = "TmuxNavigateUp",
  ["<c-l>"] = "TmuxNavigateRight",
  ["<c-\\>"] = "TmuxNavigatePrevious",
}

for key, command in pairs(navigator_keys) do
  vim.keymap.set("n", key, function()
    if vim.fn.exists(":" .. command) == 0 then
      vim.cmd("packadd vim-tmux-navigator")
    end
    vim.cmd("packadd! vim-tmux-navigator | " .. command)
  end, { silent = true })
end
