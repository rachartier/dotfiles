local signs = require("config.ui.signs")

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  virtual_text = false,
  document_highlight = {
    enabled = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.diagnostic.error,
      [vim.diagnostic.severity.WARN] = signs.diagnostic.warning,
      [vim.diagnostic.severity.INFO] = signs.diagnostic.info,
      [vim.diagnostic.severity.HINT] = signs.diagnostic.hint,
    },
  },
  severity_sort = true,
})

local orig = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
  local bufnr, winid = orig(contents, syntax, opts, ...)
  if winid then
    vim.wo[winid].winhighlight = "Normal:LspHoverNormal,FloatBorder:LspHoverBorder"
  end
  return bufnr, winid
end

vim.lsp.log.set_level(vim.log.levels.WARN)
