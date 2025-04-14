return {
	{
		languages = { "python" },
		mason = { "basedpyright", "ruff" },
		dap = { "debugpy" },
		formatter = {
			ruff_format = {
				command = "ruff",
				args = { "format", "--config", os.getenv("HOME") .. "/.config/ruff/ruff.toml", "-" },
				stdin = true,
			},
			"ruff_fix",
		},
		lsp_ignore = { "ruff" },
	},
	{
		languages = { "cs" },
		mason = { "omnisharp" },
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
		languages = { "lua" },
		formatter = { "stylua" },
		mason = { "lua_ls" },
		linter = { "selene" },
		lsp_ignore = false,
	},
	{
		languages = { "c", "cpp", "h", "hpp" },
		mason = { "clangd" },
		formatter = {},
	},
	{
		languages = { "typescript" },
		mason = { "vtsls" },
		formatter = { "prettierd" },
	},
	{
		languages = { "dockerfile" },
		mason = { "dockerls" },
		formatter = {},
		linter = { "hadolint" },
		lsp_fallback = false,
	},
	{
		languages = { "sh" },
		mason = { "bashls" },
		formatter = { "shfmt" },
		linter = { "shellcheck" },
	},
	{
		languages = { "json" },
		mason = { "jsonls" },
		formatter = { "jq", "fixjson" },
	},
	{
		languages = { "yaml" },
		mason = { "yamlls" },
		formatter = {},
	},
	{
		languages = { "markdown" },
		mason = { "marksman" },
		formatter = { "markdown-toc" },
	},
	{
		languages = { "text" },
		mason = {},
		formatter = {},
	},
	{
		languages = { "rust" },
		lsp_ignore = true,
	},
}
