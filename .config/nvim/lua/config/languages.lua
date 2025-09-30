return {
  {
    filetypes = { "python" },
    mason = { "ty", "ruff" },
    dap = { "debugpy" },
    formatter = {
      "ruff_format",
      "ruff_fix",
    },
    -- lsp_ignore = { "ruff" },
  },
  {
    filetypes = { "cs" },
    dap = { "netcoredbg" },
    lsp_ignore = true,
    formatter = {
      csharpier = {
        command = "dotnet-csharpier",
        args = { "--write-stdout" },
      },
    },
  },
  {
    filetypes = { "lua" },
    formatter = { "stylua" },
    mason = { "lua_ls" },
    linter = { "selene" },
    lsp_ignore = false,
  },
  {
    filetypes = { "c", "cpp", "h", "hpp" },
    mason = { "clangd" },
    formatter = {},
  },
  {
    filetypes = { "typescript" },
    mason = { "vtsls" },
    formatter = { "prettier" },
  },
  {
    filetypes = { "dockerfile" },
    mason = { "dockerls" },
    formatter = {},
    linter = { "hadolint" },
    lsp_fallback = false,
  },
  {
    filetypes = { "sh" },
    mason = { "bashls" },
    formatter = { "shfmt" },
    linter = { "shellcheck" },
  },
  {
    filetypes = { "json" },
    mason = { "jsonls" },
    formatter = { "jq", "fixjson" },
  },
  {
    filetypes = { "yaml" },
    mason = { "yamlls" },
    formatter = {},
  },
  {
    filetypes = { "markdown" },
    mason = { "marksman" },
    formatter = { "markdown-toc" },
  },
  {
    filetypes = { "text" },
    mason = {},
    formatter = {},
  },
  {
    filetypes = { "rust" },
    mason = { "rust_analyzer" },
    lsp_ignore = true,
  },
}
