-- local function configure_lint()
--   local lint = require("lint")
--   local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
--   local eslint = lint.linters.eslint_d
--
--   lint.linters_by_ft = {
--     javascript = { "biomejs" },
--     typescript = { "biomejs" },
--     javascriptreact = { "biomejs" },
--     typescriptreact = { "biomejs" },
--     svelte = { "biomejs" },
--     python = { "pylint" },
--   }
--
--   eslint.args = {
--     "--no-warn-ignored",
--     "--format",
--     "json",
--     "--stdin",
--     "--stdin-filename",
--     function()
--       return vim.fn.expand("%:p")
--     end,
--   }
--
--   vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
--     group = lint_augroup,
--     callback = function()
--       lint.try_lint()
--     end,
--   })
--
--   vim.keymap.set("n", "<leader>l", function()
--     lint.try_lint()
--   end, { desc = "Trigger linting for current file" })
-- end
--
-- vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
--   callback = function()
--     if not _G.nvim_lint_loaded then
--       vim.cmd("packadd nvim-lint")
--       configure_lint()
--       _G.nvim_lint_loaded = true
--     end
--   end,
-- })

local M = {}
local lint = require("lint")

-- 2. Explicitly define your options table locally (replaces lazy.nvim's 'opts')
local opts = {
  events = { "BufWritePost", "BufReadPost", "InsertLeave" },
  linters_by_ft = {
    fish = { "fish" },
  },
  linters = {
    -- Your custom linter configurations go here
  },
}

-- 3. Loop over your config and inject it into nvim-lint
for name, linter in pairs(opts.linters) do
  if type(linter) == "table" and type(lint.linters[name]) == "table" then
    lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
    if type(linter.prepend_args) == "table" then
      lint.linters[name].args = lint.linters[name].args or {}
      vim.list_extend(lint.linters[name].args, linter.prepend_args)
    end
  else
    lint.linters[name] = linter
  end
end
lint.linters_by_ft = opts.linters_by_ft

-- 4. Debounce helper function
function M.debounce(ms, fn)
  local timer = vim.uv.new_timer()
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

-- 5. Orchestrate custom lint logic
function M.lint()
  local names = lint._resolve_linter_by_ft(vim.bo.filetype)
  names = vim.list_extend({}, names)

  -- Add fallback linters
  if #names == 0 then
    vim.list_extend(names, lint.linters_by_ft["_"] or {})
  end

  -- Add global linters
  vim.list_extend(names, lint.linters_by_ft["*"] or {})

  -- Filter logic (Replaced LazyVim.warn with native vim.notify)
  local ctx = { filename = vim.api.nvim_buf_get_name(0) }
  ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
  names = vim.tbl_filter(function(name)
    local linter = lint.linters[name]
    if not linter then
      vim.notify("Linter not found: " .. name, vim.log.levels.WARN, { title = "nvim-lint" })
    end
    return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
  end, names)

  -- Run the resolved linters
  if #names > 0 then
    lint.try_lint(names)
  end
end

-- 6. Register Autocommands
vim.api.nvim_create_autocmd(opts.events, {
  group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
  callback = M.debounce(100, M.lint),
})
