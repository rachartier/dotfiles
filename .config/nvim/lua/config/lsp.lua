local M = {}

local lsp_util = require("lspconfig.util")
local util = require("utils")

local pid = vim.fn.getpid()

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

	-- "pyright",
	["basedpyright"] = {

		before_init = function(_, config)
			config.settings.python.pythonPath = util.get_python_path(config.root_dir)
		end,
		root_dir = lsp_util.root_pattern("pyrightconfig.json"),
		settings = {
			pyright = {
				autoImportCompletion = true,
			},
			python = {
				analysis = {
					autoSearchPaths = true,
					diagnosticMode = "workspace",
					useLibraryCodeForTypes = true,
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
		root_dir = lsp_util.root_pattern("*.sln"),
		analyze_open_documents_only = false,
		enable_decompilation_support = true,
		enable_editorconfig_support = true,
		enable_import_completion = true,
		enable_ms_build_load_projects_on_demand = false,
		enable_roslyn_analyzers = true,
		organize_imports_on_format = true,
		sdk_include_prereleases = false,
		filetypes = { "cs", "vb", "csproj", "sln", "slnx", "props", "csx", "props", "targets" },
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
