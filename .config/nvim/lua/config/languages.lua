return {
	{
		languages = { "python" },
		mason = { "basedpyright", "ruff" },
		dap = { "debugpy" },
		formatter = { "ruff_format", "ruff_fix" },
		lsp_ignore = { "ruff" },
		lsp_settings = {
			root_dir = function(fname)
				return require("lspconfig.util").root_pattern(unpack({
					"main.py",
					"pyproject.toml",
					"setup.py",
					"setup.cfg",
					"requirements.txt",
					"Pipfile",
					"pyrightconfig.json",
					".git",
				}))(fname)
			end,
			settings = {
				basedpyright = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						useLibraryCodeForTypes = true,
						typecheckingMode = "standard",
						-- ignore = { "*" },
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
				return require("lspconfig.util").root_pattern(unpack({
					"*.sln",
					"*.csproj",
				}))(fname)
			end,
			-- cmd = {
			-- 	os.getenv("HOME") .. "/.local/share/nvim/mason/bin/omnisharp",
			-- 	"--languagesserver",
			-- 	"--hostPID",
			-- 	tostring(pid),
			-- },
			settings = {
				FormattingOptions = {
					EnableEditorConfigSupport = true,
					OrganizeImports = true,
				},
				MsBuild = {
					LoadProjectsOnDemand = nil,
				},
				RoslynExtensionsOptions = {
					EnableAnalyzersSupport = true,
					EnableImportCompletion = true,
					AnalyzeOpenDocumentsOnly = nil,
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
		linter = { "selene" },
		lsp_ignore = true,
	},
	{
		languages = { "c", "cpp", "h", "hpp" },
		mason = { "clangd" },
		formatter = {
			-- ["clang-format"] = {
			-- 	command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/clang-format",
			-- 	inherit = false,
			-- 	args = {
			-- 		"--style=file:" .. linter_config .. "/clang-format",
			-- 		"$FILENAME",
			-- 	},
			-- },
		},
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
			-- explicitly add default filetypes, so that we can extend
			-- them in related extras
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
		-- linter = {
		-- 	"markdownlint",
		-- },
	},
	{
		languages = { "text" },
		mason = {},
		formatter = {},
	},
	-- {
	-- 	languages = { "c", "h", "cpp", "hpp" },
	-- 	mason = { "clangd" },
	-- 	formatter = { "clang-format",  },
	-- 	lsp_ignore = true,
	-- },
	{
		languages = { "rust" },
		lsp_ignore = true,
	},
}
