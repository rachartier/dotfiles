local M = {}

local pid = vim.fn.getpid()

M.ensure_installed = {
	"lua-language-server",
	"clangd",
	"omnisharp",
	"basedpyright",
	"dockerfile-language-server",
	"json-lsp",
	"bash-language-server",
	"clangd",
	"marksman",
}

M.lsps = {
	["lua_ls"] = {
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

	["basedpyright"] = {
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

	["omnisharp"] = {
		cmd = {
			"/home/rachartier/.local/share/nvim/mason/bin/omnisharp",
			"--languageserver",
			"--hostPID",
			tostring(pid),
		},
		-- root_dir = lsp_util.root_pattern("*.sln"),
		-- analyze_open_documents_only = false,
		-- enable_decompilation_support = true,
		-- enable_editorconfig_support = true,
		-- enable_import_completion = true,
		-- enable_ms_build_load_projects_on_demand = false,
		-- enable_roslyn_analyzers = true,
		-- organize_imports_on_format = true,
		-- sdk_include_prereleases = false,
		-- filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "props", "targets" },

		settings = {
			FormattingOptions = {
				-- Enables support for reading code style, naming convention and analyzer
				-- settings from .editorconfig.
				EnableEditorConfigSupport = true,
				-- Specifies whether 'using' directives should be grouped and sorted during
				-- document formatting.
				OrganizeImports = true,
			},
			MsBuild = {
				-- If true, MSBuild project system will only load projects for files that
				-- were opened in the editor. This setting is useful for big C# codebases
				-- and allows for faster initialization of code navigation features only
				-- for projects that are relevant to code that is being edited. With this
				-- setting enabled OmniSharp may load fewer projects and may thus display
				-- incomplete reference lists for symbols.
				LoadProjectsOnDemand = nil,
			},
			RoslynExtensionsOptions = {
				-- Enables support for roslyn analyzers, code fixes and rulesets.
				EnableAnalyzersSupport = true,
				-- Enables support for showing unimported types and unimported extension
				-- methods in completion lists. When committed, the appropriate using
				-- directive will be added at the top of the current file. This option can
				-- have a negative impact on initial completion responsiveness,
				-- particularly for the first few completion sessions after opening a
				-- solution.
				EnableImportCompletion = true,
				-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
				-- true
				AnalyzeOpenDocumentsOnly = nil,
			},
			Sdk = {
				-- Specifies whether to include preview versions of the .NET SDK when
				-- determining which version to use for project loading.
				IncludePrereleases = true,
			},
		},
	},
	["clangd"] = {
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
		},
	},
	"marksman",
	"dockerls",
	"jsonls",
	"bashls",
}

return M
