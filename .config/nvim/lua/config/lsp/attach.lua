local M = {}

local methods = vim.lsp.protocol.Methods

local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
  return signature_help({
    max_height = math.floor(vim.o.lines * vim.g.float_height),
    max_width = math.floor(vim.o.columns * vim.g.float_width),
  })
end

function M.on_attach(client, bufnr)
  vim.lsp.document_color.enable(true, { bufnr = bufnr }, {
    style = "virtual",
  })

  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, { buffer = bufnr, desc = "hover documentation" })

  if client:supports_method(methods.textDocument_codeAction) then
    vim.keymap.set({ "n" }, "<leader>ca", function()
      require("tiny-code-action").code_action({})
    end, { noremap = true, silent = true, desc = "code action" })
  end

  if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
    vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
  end
end

return M
