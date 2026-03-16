local border = require("config.ui.border").default_border

local function collect_tools(server_settings)
  local excluded_tools = {
    "stylelint",
    "trim_whitespace", "trim_newlines", "squeeze_blanks",
    "injected", "ruff_fix", "ruff_format",
  }
  local lsp_servers, formatters_linters, dap_tools = {}, {}, {}

  for _, config in ipairs(server_settings) do
    if config.mason then
      for _, server in ipairs(config.mason) do
        table.insert(lsp_servers, server)
      end
    end

    if vim.g.dotfile_config_type ~= "minimal" and config.dap then
      for _, tool in ipairs(config.dap) do
        table.insert(dap_tools, tool)
      end
    end

    local function add_tools(tool_type)
      if config[tool_type] then
        for tool, tool_name in pairs(config[tool_type]) do
          table.insert(formatters_linters, type(tool_name) == "table" and tool or tool_name)
        end
      end
    end
    add_tools("formatter")
    add_tools("linter")
  end

  local function filter_and_deduplicate(tools)
    table.sort(tools)
    local unique_tools = vim.fn.uniq(tools)
    return vim.tbl_filter(function(tool)
      return not vim.tbl_contains(excluded_tools, tool)
    end, unique_tools)
  end

  return { lsp = lsp_servers, dap = dap_tools, tools = filter_and_deduplicate(formatters_linters) }
end

vim.schedule(function()
  vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",     -- required by mason-nvim-dap at setup time
    "https://github.com/jay-babu/mason-nvim-dap.nvim",
    "https://github.com/zapling/mason-conform.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/neovim/nvim-lspconfig",
  }, { confirm = false })

  require("mason").setup({
    registries = {
      "github:mason-org/mason-registry",
      "github:Crashdummyy/mason-registry",
    },
    ensure_installed = { "stylua", "shfmt" },
    ui = {
      border = border,
      keymaps = {
        toggle_server_expand  = "<CR>",
        install_server        = "i",
        update_server         = "u",
        check_server_version  = "c",
        update_all_servers    = "U",
        check_outdated_servers = "C",
        uninstall_server      = "X",
        cancel_installation   = "<C-c>",
      },
    },
  })

  local on_attach = require("config.lsp.attach").on_attach

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local bufnr = args.buf

      if client and (client.name == "GitHub Copilot" or client.name == "copilot") then
        vim.lsp.inline_completion.enable()
      end

      on_attach(client, bufnr)
    end,
    desc = "lsp attach",
  })

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local server_settings = require("config.languages")
  local tools = collect_tools(server_settings)

  require("mason-lspconfig").setup({
    ensure_installed = tools.lsp,
    automatic_enable = false,
    automatic_installation = true,
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
    if config.mason then
      for _, server_name in ipairs(config.mason) do
        local ignore = false
        if type(config.lsp_ignore) == "table" then
          ignore = vim.tbl_contains(config.lsp_ignore, server_name)
        else
          ignore = config.lsp_ignore or false
        end

        if not ignore then
          vim.lsp.config(server_name, { capabilities = capabilities })
          vim.lsp.enable(server_name)
        end
      end
    end
  end
end)
