local linters = require("config.linter").enabled
local formatters = require("config.formatter").enabled
local extras = require("config").extras
local lsps = require("config.lsp").lsps

-- PENDING https://github.com/mfussenegger/nvim-lint/issues/355
-- for _, list in pairs(linters.enabled) do
--     table.insert(list, "typos")
--     table.insert(list, "editorconfig-checker")
-- end

local function lint_triggers()
	local function do_lint()
		vim.defer_fn(function()
			if vim.bo.buftype ~= "" then
				return
			end

			-- GUARD only when in lua, only lint when selene file available
			-- https://github.com/mfussenegger/nvim-lint/issues/370#issuecomment-1729671151
			if vim.bo.ft == "lua" then
				local noSeleneConfig = vim.loop.fs_stat((vim.loop.cwd() or "") .. "/selene.toml") == nil
				if noSeleneConfig then
					local luaLinters = require("lint").linters_by_ft.lua
					local noSelene = vim.tbl_filter(function(linter)
						return linter ~= "selene"
					end, luaLinters)
					require("lint").try_lint(noSelene)
					return
				end
			end

			require("lint").try_lint()
		end, 1)
	end

	vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "TextChanged", "FocusGained" }, {
		callback = do_lint,
	})

	-- due to auto-save.nvim, we need the custom event "AutoSaveWritePost"
	-- instead of "BufWritePost" to trigger linting to prevent race conditions
	vim.api.nvim_create_autocmd("User", {
		pattern = "AutoSaveWritePost",
		callback = do_lint,
	})

	do_lint() -- run once on initialization
end

return {
	{ -- Linter integration
		"mfussenegger/nvim-lint",
		event = "VeryLazy",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = linters

			for name, value in pairs(require("config.linter").by_ft_options) do
				lint.linters[name].args = value.args
			end

			lint_triggers()
		end,
	},
	{ -- Formatter integration
		"stevearc/conform.nvim",
		enabled = true,
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		config = function()
			require("conform").setup({
				formatters_by_ft = formatters,
				format_on_save = function(bufnr)
					local bufnr = vim.api.nvim_get_current_buf()
					local errors = vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.ERROR } })

					local clients = vim.lsp.get_clients()

					-- fix for omnisharp
					for _, client in pairs(clients) do
						if client.name == "omnisharp" then
							if #errors > 0 then
								return
							end
						end
					end

					return {
						quiet = true,
						timeout_ms = 500,
						lsp_fallback = true,
					}
				end,
			})

			require("conform").formatters = require("config.formatter").by_ft_options
		end,
	},
}
