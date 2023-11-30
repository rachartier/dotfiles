local M = {}

M.lsps = {
	"lua_ls",
	"dockerls",
	"jsonls",
	"bashls",
	"pyright",
	"omnisharp",
	-- "clangd",
}

M.linters = {
	lua = { "selene" },
	sh = { "shellcheck" },
	markdown = { "markdownlint", "vale" },
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
	json = { "fixjson" },
	jsonc = { "fixjson" },
	lua = { "stylua", "ast-grep" },
	python = { "black", "autoflake", "isort" },
	yaml = { "prettier" },
	html = { "prettier" },
	markdown = {
		"markdown-toc",
		"markdownlint",
		"injected",
	},
	cs = { "csharpier" },
	css = { "stylelint", "prettier" },
	sh = { "shellcheck", "shfmt" },
	["_"] = { "trim_whitespace", "trim_newlines", "squeeze_blanks" },
	["*"] = { "typos" },
}

M.extras = {
	"debugpy",
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
}

M.linters_by_ft_options = {
	codespell = {
		args = { "--toml=" .. linter_config .. "/codespell.toml" },
	},
	shellcheck = {
		args = { "--shell=bash", "--format=json", "-" },
	},
	yamllint = {
		args = { "--config-file=" .. linter_config .. "/yamllint.yaml", "--format=parsable", "-" },
	},
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

return M
