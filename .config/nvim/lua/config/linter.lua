local M = {}

local linter_config = require("utils").linter_config_folder

M.enabled = {
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
	dockerfile = { "hadolint" },
	bash = { "shellcheck" },
	zsh = { "shellcheck" },

	typos = {},
	["editorconfig-checker"] = {},
}

M.by_ft_options = {
	codespell = {
		args = { "--toml=" .. linter_config .. "/codespell.toml" },
	},
	shellcheck = {
		args = {
			"--shell=bash",
			"--format=json",
			"-",
		},
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
	["editorconfig-checker"] = {
		args = {
			"-no-color",
			"-disable-max-line-length", -- only rule of thumb
			"-disable-trim-trailing-whitespace", -- will be formatted anyway
		},
	},
}

return M
