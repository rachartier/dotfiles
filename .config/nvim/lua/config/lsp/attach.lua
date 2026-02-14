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

M.lsp_rename = function()
  local curr_name = vim.fn.expand("<cword>")
  local value = vim.fn.input("LSP Rename: ", curr_name)
  local lsp_params = vim.lsp.util.make_position_params()

  if not value or #value == 0 or curr_name == value then
    return
  end

  lsp_params.newName = value
  vim.lsp.buf_request(0, "textDocument/rename", lsp_params, function(_, res, ctx, _)
    if not res then
      return
    end

    local client = vim.lsp.get_client_by_id(ctx.client_id)
    vim.lsp.util.apply_workspace_edit(res, client.offset_encoding)

    local changed_files_count = 0
    local changed_instances_count = 0

    if res.documentChanges then
      for _, changed_file in pairs(res.documentChanges) do
        changed_instances_count = changed_instances_count + #changed_file.edits
        changed_files_count = changed_files_count + 1
      end
    elseif res.changes then
      for _, changed_file in pairs(res.changes) do
        changed_instances_count = changed_instances_count + #changed_file
        changed_files_count = changed_files_count + 1
      end
    end

    vim.notify(
      string.format(
        "Renamed %s instance%s in %s file%s.",
        changed_instances_count,
        changed_instances_count == 1 and "" or "s",
        changed_files_count,
        changed_files_count == 1 and "" or "s"
      )
    )

    vim.cmd("silent! wa")
  end)
end

function M.on_attach(client, bufnr)
  vim.lsp.document_color.enable(true, bufnr, {
    style = "virtual",
  })
  vim.lsp.on_type_formatting.enable()

  vim.keymap.set("n", "K", function() vim.lsp.buf.hover( {border = "rounded",}) end, { buffer = bufnr, desc = "hover documentation" })

  if client:supports_method(methods.textDocument_codeAction) then
    vim.keymap.set({ "n" }, "<leader>ca", function()
            require("tiny-code-action").code_action({ })
    end, { noremap = true, silent = true, desc = "code action" })
  end

   if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
    vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
  end
end

return M
