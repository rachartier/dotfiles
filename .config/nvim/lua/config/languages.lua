local pid = vim.fn.getpid()
local linter_config = require("utils").linter_config_folder

return {
	{
		languages = { "python" },
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
		languages = { "cs" },
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
		mason = { "lua_ls" },
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
	-- {
	-- 	languages = { "c", "cpp" },
	-- 	mason = { "clangd" },
	-- 	formatter = {
	-- 		-- ["clang-format"] = {
	-- 		-- 	command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/clang-format",
	-- 		-- 	inherit = false,
	-- 		-- 	args = {
	-- 		-- 		"--style=file:" .. linter_config .. "/clang-format",
	-- 		-- 		"$FILENAME",
	-- 		-- 	},
	-- 		-- },
	-- 		"typos",
	-- 	},
	-- 	lsp_settings = {
	-- 		cmd = {
	-- 			"clangd",
	-- 			"--offset-encoding=utf-16",
	-- 		},
	-- 	},
	-- },

	{
		languages = { "typescript" },
		mason = { "tsserver" },
		formatter = { "prettierd" },
	},
	{
		languages = { "docker" },
		mason = { "dockerls" },
		formatter = { "hadolint", "typos" },
	},
	{
		languages = { "sh" },
		mason = { "bashls" },
		formatter = { "shfmt", "typos" },
		linter = { "shellcheck" },
	},
	{
		languages = { "json" },
		mason = { "jsonls" },
		formatter = { "jq", "fixjson", "typos" },
	},
	{
		languages = { "yaml" },
		mason = { "yamlls" },
		formatter = { "typos" },
	},
	{
		languages = { "markdown" },
		mason = { "marksman" },
		formatter = { "markdown-toc", "injected", "typos" },
		linter = {
			"markdownlint",
		},
	},
	{
		languages = { "text" },
		mason = {},
		formatter = { "typos" },
	},
}
