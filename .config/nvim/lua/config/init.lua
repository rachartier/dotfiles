local M = {}

local util = require("utils")
local lsp_util = require("lspconfig/util")

local pid = vim.fn.getpid()

if vim.g.neovide then
	M.pumblend = 25 -- Popup blend
	M.winblend = 45 -- Window blend
else
	M.pumblend = 0
	M.winblend = 0
end

M.gif_alpha_enabled = true

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

M.linters = {
	lua = { "selene" },
	sh = { "shellcheck" },
	markdown = { "markdownlint" },
	yaml = { "yamllint" },
	python = {
		-- "pylint",
		-- "ruff",
	},
	gitcommit = {},
	json = {},
	toml = {},
}

M.formatters = {
	json = { "fixjson", "typos" },
	jsonc = { "fixjson", "typos" },
	lua = { "stylua", "ast-grep", "typos" },
	python = { "black", "autoflake", "isort", "typos" },
	yaml = { "typos" },
	html = { { "prettier" }, "typos" },
	htmldjango = { { "prettier" }, "typos" },
	markdown = {
		"markdown-toc",
		"markdownlint",
		"injected",
	},
	c = { "clang-format", "typos" },
	cs = { "csharpier", "typos" },
	css = { "stylelint", "prettier", "typos" },
	sh = { "shellcheck", "shfmt", "typos" },
	["_"] = { "trim_whitespace", "trim_newlines", "squeeze_blanks" },
}

M.extras = {
	"debugpy",
	"netcoredbg",
	"ruff",
}

local linter_config = require("utils").linter_config_folder
M.formatters_by_ft_options = {
	markdownlint = {
		prepend_args = {
			"--config=" .. linter_config .. "/markdownlint.yaml",
		},
	},
	autoflake = {
		prepend_args = {
			"--remove-all-unused-imports",
			"--remove-unused-variables",
		},
	},
	black = {
		prepend_args = {
			"--line-length",
			"400",
		},
	},
	csharpier = {
		command = "dotnet-csharpier",
		args = { "--write-stdout" },
	},
}

M.formatters_by_ft_options["clang-format"] = {
	command = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/clang-format",
	inherit = false,
	args = {
		"--style=file:" .. linter_config .. "/clang-format",
		"$FILENAME",
	},
}

M.linters_by_ft_options = {
	codespell = {
		args = { "--toml=" .. linter_config .. "/codespell.toml" },
	},
	shellcheck = {
		args = { "--shell=bash", "--format=json", "-" },
	},
	-- yamllint = {
	-- 	args = { "--config-file=" .. linter_config .. "/yamllint.yaml", "--format=parsable", "-" },
	-- },
	markdownlint = {
		args = {
			"--disable=no-trailing-spaces", -- not disabled in config, so it's enabled for formatting
			"--disable=no-multiple-blanks",
			"--config=" .. linter_config .. "/markdownlint.yaml",
		},
	},
}
M.linters_by_ft_options["editorconfig-checker"] = {
	args = {
		"-no-color",
		"-disable-max-line-length", -- only rule of thumb
		"-disable-trim-trailing-whitespace", -- will be formatted anyway
	},
}

local U = require("utils")
vim.fn.sign_define("DiagnosticSignError", { text = U.diagnostic_signs.error, texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = U.diagnostic_signs.warning, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = U.diagnostic_signs.info, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = U.diagnostic_signs.hint, texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
	float = { border = U.default_border },
	underline = true,
	update_in_insert = false,
	virtual_lines = {
		highlight_whole_line = false,
		only_current_line = true,
	},
	virtual_text = {
		--   spacing = 4,
		-- source = "if_many",
		prefix = "●",
		-- prefix = "icons",
	},
	-- virtual_text = {
	-- 	prefix = function(diagnostic)
	-- 		if diagnostic.severity == vim.diagnostic.severity.ERROR then
	-- 			return U.diagnostic_signs.error
	-- 		elseif diagnostic.severity == vim.diagnostic.severity.WARN then
	-- 			return U.diagnostic_signs.warning
	-- 		elseif diagnostic.severity == vim.diagnostic.severity.INFO then
	-- 			return U.diagnostic_signs.info
	-- 		else
	-- 			return U.diagnostic_signs.hint
	-- 		end
	-- 	end,
	-- },
	signs = {
		["WARN"] = U.diagnostic_signs.warning,
		["ERROR"] = U.diagnostic_signs.error,
		["INFO"] = U.diagnostic_signs.info,
		["HINT"] = U.diagnostic_signs.hint,
	},
	severity_sort = true,
})

return M
