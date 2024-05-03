local function lint_triggers()
	local function do_lint()
		vim.defer_fn(function()
			if vim.bo.buftype ~= "" then
				return
			end

			-- -- GUARD only when in lua, only lint when selene file available
			-- -- https://github.com/mfussenegger/nvim-lint/issues/370#issuecomment-1729671151
			-- if vim.bo.ft == "lua" then
			-- 	local noSeleneConfig = vim.loop.fs_stat((vim.loop.cwd() or "") .. "/selene.toml") == nil
			-- 	if noSeleneConfig then
			-- 		local luaLinters = require("lint").linters_by_ft.lua
			-- 		local noSelene = vim.tbl_filter(function(linter)
			-- 			return linter ~= "selene"
			-- 		end, luaLinters)
			-- 		require("lint").try_lint(noSelene)
			-- 		return
			-- 	end
			-- end

			require("lint").try_lint()
		end, 1)
	end

	vim.api.nvim_create_autocmd({ "BufReadPost", "InsertLeave", "TextChanged", "FocusGained" }, {
		callback = do_lint,
	})

	do_lint() -- run once on initialization
end

return {
	{ -- Linter integration
		"mfussenegger/nvim-lint",
		event = "LazyFile",
		config = function()
			local lint = require("lint")
			local linter_by_ft = require("config.languages")

			for _, server_config in pairs(linter_by_ft) do
				for _, language_name in pairs(server_config.languages) do
					lint.linters_by_ft[language_name] = server_config.linter or {}
				end
			end

			lint_triggers()
		end,
	},
	{ -- Formatter integration
		"stevearc/conform.nvim",
		event = "LazyFile",
		enabled = true,
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
		config = function()
			local languages = require("config.languages")
			local formatters_by_ft = {}
			local formatters_settings = {}

			for _, server_config in pairs(languages) do
				for _, language_name in pairs(server_config.languages) do
					local formatters = {}
					for tool_name, tool in pairs(server_config.formatter or {}) do
						if type(tool) == "table" then
							table.insert(formatters, tool_name)
							formatters_settings[tool_name] = tool
						else
							table.insert(formatters, server_config.formatter)
						end
					end

					formatters_by_ft[language_name] = formatters
				end
			end
			formatters_by_ft["_"] = languages.default

			require("conform").setup({
				formatters_by_ft = formatters_by_ft,
				format_on_save = function(bufnr)
					local errors = vim.diagnostic.get(bufnr, { severity = { min = vim.diagnostic.severity.ERROR } })
					local clients = vim.lsp.buf_get_clients()

					-- fix for omnisharp
					for _, client in pairs(clients) do
						if client.name == "omnisharp" then
							if #errors > 0 then
								return
							end
						end
					end

					return {
						timeout_ms = 500,
						lsp_fallback = true,
					}
				end,
				formatters = formatters_settings,
			})
		end,
	},
}
