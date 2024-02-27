local M = {}

if vim.g.neovide then
	M.pumblend = 25 -- Popup blend
	M.winblend = 45 -- Window blend
else
	M.pumblend = 0
	M.winblend = 0
end

M.gif_alpha_enabled = true

M.lsps = {
	"lua_ls",
	"dockerls",
	"jsonls",
	"bashls",
	"pyright",
	-- "omnisharp",
	"clangd",
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
	html = { "prettier", "typos" },
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
			"--line-length 400",
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

return M
