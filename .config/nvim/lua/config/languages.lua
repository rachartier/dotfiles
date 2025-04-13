return {
	{
		languages = { "python" },
		mason = { "basedpyright", "ruff" },
		dap = { "debugpy" },
		formatter = { "ruff_format", "ruff_fix" },
		lsp_ignore = { "ruff" },
		lsp_settings = {
			root_dir = function(fname)
				return require("lspconfig.util").root_pattern(
					"main.py",
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					"pyrightconfig.json",
					".git"
				)(fname)
			end,
			settings = {
				basedpyright = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						useLibraryCodeForTypes = true,
						typecheckingMode = "standard",
					},
				},
			},
		},
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
		lsp_settings = {
			root_dir = function(fname)
				return require("lspconfig.util").root_pattern("*.sln", "*.csproj")(fname)
			end,
			settings = {
				FormattingOptions = {
					EnableEditorConfigSupport = true,
					OrganizeImports = true,
				},
				RoslynExtensionsOptions = {
					EnableAnalyzersSupport = true,
					EnableImportCompletion = true,
				},
				Sdk = {
					IncludePrereleases = true,
				},
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
		lsp_settings = {
			cmd = {
				"clangd",
				"--offset-encoding=utf-16",
			},
		},
	},
	{
		languages = { "typescript" },
		mason = { "vtsls" },
		formatter = { "prettierd" },
		lsp_settings = {
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
			settings = {
				complete_function_calls = true,
				vtsls = {
					enableMoveToFileCodeAction = true,
					autoUseWorkspaceTsdk = true,
					experimental = {
						completion = {
							enableServerSideFuzzyMatch = true,
						},
					},
				},
				typescript = {
					updateImportsOnFileMove = { enabled = "always" },
					suggest = {
						completeFunctionCalls = true,
					},
					inlayHints = {
						enumMemberValues = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						parameterNames = { enabled = "literals" },
						parameterTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						variableTypes = { enabled = false },
					},
				},
			},
		},
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
