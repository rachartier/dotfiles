local signs = require("config.ui.signs")

vim.diagnostic.config({
  -- float = {
  -- 	border = require("config.ui.border").default_border,
  -- },
  underline = true,
  update_in_insert = false,
  -- virtual_lines = {
  --     highlight_whole_line = false,
  --     -- only_current_line = true,
  -- },
  virtual_text = false, -- virtual_text = {
  -- 	prefix = function(diagnostic)
  -- 		if diagnostic.severity == vim.diagnostic.severity.ERROR then
  -- 			return U.signs.diagnostic.error
  -- 		elseif diagnostic.severity == vim.diagnostic.severity.WARN then
  -- 			return U.signs.diagnostic.warning
  -- 		elseif diagnostic.severity == vim.diagnostic.severity.INFO then
  -- 			return U.signs.diagnostic.info
  -- 		else
  -- 			return U.signs.diagnostic.hint
  -- 		end
  -- 	end,
  -- },
  document_highlight = {
    enabled = true,
  },
  capabilities = {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
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

vim.lsp.log.set_level(vim.log.levels.WARN)
