return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" }, -- Lazy loads conform on save
  cmd = { "ConformInfo" },   -- Lazy loads conform on this command
  opts = {
    formatters_by_ft = {
      qml = { "qmlformat" },
      bash = { "shfmt" },
      sh = { "shfmt" },
    },
  },
}
