local pid = vim.fn.getpid()
local linter_config = require("utils").linter_config_folder

return {
	{
		language = { "python" },
		mason = { "basedpyright" },
		dap = { "debugpy" },
		formatter = { "ruff", "ruff_format", "ruff_fix", "typos" },
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
						-- ignore = { "*" },
					},
				},
			},
		},
	},
	{
		language = "cs",
		mason = { "omnisharp" },
		dap = { "netcoredbg" },
		formatter = {
			csharpier = {
				command = "dotnet-csharpier",
				args = { "--write-stdout" },
			},
			"typos",
		},
		lsp_settings = {
			cmd = {
				"/home/rachartier/.local/share/nvim/mason/bin/omnisharp",
				"--languageserver",
				"--hostPID",
				tostring(pid),
			},
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
		language = { "lua" },
		mason = { "lua_ls" },
		formatter = { "stylua", "typos" },
		linter = { "selene" },
		lsp_settings = {
			settings = {
				Lua = {
					workspace = {
						checkThirdParty = false,
					},
					codeLens = {
						enable = true,
					},
					completion = {
						callSnippet = "Replace",
					},
					hint = {
						enabled = true,
					},
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		},
	},
	{
		language = { "c", "cpp" },
		mason = { "clangd" },
		formatter = {
			["clang-format"] = {
				command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/clang-format",
				inherit = false,
				args = {
					"--style=file:" .. linter_config .. "/clang-format",
					"$FILENAME",
				},
			},
			"typos",
		},
		lsp_settings = {
			cmd = {
				"clangd",
				"--offset-encoding=utf-16",
			},
		},
	},
	{
		language = { "docker" },
		mason = { "dockerls" },
		formatter = { "hadolint", "typos" },
	},
	{
		language = { "sh" },
		mason = { "bashls" },
		formatter = { "shfmt" },
		linter = { "shellcheck" },
	},
	{
		language = { "json" },
		mason = { "jsonls" },
		formatter = { "jq", "fixjson", "typos" },
	},
	{
		language = { "yaml" },
		mason = { "yamlls" },
		formatter = { "typos" },
	},
	{
		language = { "markdown" },
		mason = { "marksman" },
		formatter = { "markdown-toc", "injected", "typos" },
		linter = {
			markdownlint = {
				prepend_args = {
					"--config=" .. linter_config .. "/markdownlint.yaml",
				},
			},
		},
	},
}
