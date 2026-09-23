vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap", -- required by mason-nvim-dap at setup time
  "https://github.com/jay-babu/mason-nvim-dap.nvim",
  "https://github.com/zapling/mason-conform.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/neovim/nvim-lspconfig",
}, { confirm = false })

local function collect_tools(server_settings)
  local excluded_tools = { "ruff_fix", "ruff_format" }
  local lsp_servers, formatters_linters, dap_tools = {}, {}, {}

  for _, config in ipairs(server_settings) do
    vim.list_extend(lsp_servers, config.mason or {})

    if vim.g.dotfile_config_type ~= "minimal" then
      vim.list_extend(dap_tools, config.dap or {})
    end

    for _, tool_type in ipairs({ "formatter", "linter" }) do
      for tool, tool_name in pairs(config[tool_type] or {}) do
        table.insert(formatters_linters, type(tool_name) == "table" and tool or tool_name)
      end
    end
  end

  local tools = vim.tbl_filter(function(tool)
    return not vim.list_contains(excluded_tools, tool)
  end, vim.list.unique(formatters_linters))

  return { lsp = lsp_servers, dap = dap_tools, tools = tools }
end

vim.schedule(function()
  require("mason").setup({
    registries = {
      "github:mason-org/mason-registry",
      "github:Crashdummyy/mason-registry",
    },
    ui = {
      border = require("config.ui.border").default_border,
    },
  })

  local on_attach = require("config.lsp.attach").on_attach

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
    end,
    desc = "lsp attach",
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
  vim.lsp.config("*", { capabilities = capabilities })

  local server_settings = require("config.languages")
  local tools = collect_tools(server_settings)

  require("mason-lspconfig").setup({
    ensure_installed = tools.lsp,
    automatic_enable = false,
  })

  require("mason-conform").setup({
    ensure_installed = tools.tools,
    automatic_installation = true,
  })

  if vim.g.dotfile_config_type ~= "minimal" then
    require("mason-nvim-dap").setup({
      ensure_installed = tools.dap,
      automatic_installation = true,
    })
  end

  for _, config in ipairs(server_settings) do
    if not config.lsp_ignore then
      vim.lsp.enable(config.mason or {})
    end
  end
end)
