vim.pack.add({
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/stevearc/conform.nvim",
}, { confirm = false })

local function lint_triggers()
  local function do_lint()
    vim.defer_fn(function()
      if vim.bo.buftype ~= "" then
        return
      end
      require("lint").try_lint()
    end, 1)
  end

  vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "TextChanged", "FocusGained" }, {
    callback = function()
      do_lint()
    end,
    desc = "auto lint",
  })

  do_lint()
end

vim.schedule(function()
  local lint = require("lint")
  local formatters_by_ft = {}
  local formatters_settings = {}
  local no_lsp_format = {}

  for _, config in ipairs(require("config.languages")) do
    local formatters = {}
    for tool_name, tool in pairs(config.formatter or {}) do
      if type(tool) == "table" then
        table.insert(formatters, tool_name)
        formatters_settings[tool_name] = tool
      else
        table.insert(formatters, tool)
      end
    end

    for _, ft in ipairs(config.filetypes) do
      lint.linters_by_ft[ft] = config.linter or {}
      formatters_by_ft[ft] = formatters
      no_lsp_format[ft] = config.lsp_fallback == false
    end
  end

  lint_triggers()

  vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

  require("conform").setup({
    formatters_by_ft = formatters_by_ft,
    format_on_save = function(bufnr)
      local lsp_format = no_lsp_format[vim.bo[bufnr].filetype] and "never" or "fallback"
      return { timeout_ms = 1500, lsp_format = lsp_format }
    end,
    formatters = formatters_settings,
  })
end)
