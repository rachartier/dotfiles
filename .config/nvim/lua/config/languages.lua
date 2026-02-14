return {
  {
    filetypes = { "*" },
    mason = { "copilot" },
  },
  {
    filetypes = { "python" },
    mason = { "basedpyright", "ruff" },
    dap = { "debugpy" },
    formatter = {
      "ruff_format",
      "ruff_fix",
    },
  },
  {
    filetypes = { "cs" },
    treesitter = { "c_sharp" },
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
  },
  {
    filetypes = { "c", "cpp", "h", "hpp" },
    treesitter = { "c", "cpp" },
    mason = { "clangd" },
  },
  {
    filetypes = { "typescript" },
    mason = { "vtsls" },
    formatter = { "prettier" },
  },
  {
    filetypes = { "dockerfile" },
    mason = { "dockerls" },
    linter = { "hadolint" },
    lsp_fallback = false,
  },
  {
    filetypes = { "sh" },
    treesitter = { "bash" },
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
  },
  {
    filetypes = { "markdown" },
    mason = { "marksman" },
    formatter = { "markdown-toc" },
  },
  {
    filetypes = { "text" },
  },
}
