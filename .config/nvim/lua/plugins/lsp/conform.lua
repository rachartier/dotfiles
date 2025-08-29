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
    callback = function()
      do_lint()
    end,
    desc = "Auto lint",
  })

  do_lint() -- run once on initialization
end

return {
  { -- Linter integration
    "mfussenegger/nvim-lint",
    event = { "LazyFile" },
    config = function()
      local lint = require("lint")
      local linter_by_ft = require("config.languages")

      for _, server_config in pairs(linter_by_ft) do
        for _, language_name in pairs(server_config.filetypes) do
          lint.linters_by_ft[language_name] = server_config.linter or {}
        end
      end

      lint_triggers()
    end,
  },
  { -- Formatter integration
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    enabled = true,
    config = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      local languages = require("config.languages")
      local formatters_by_ft = {}
      local formatters_settings = {}

      for _, server_config in pairs(languages) do
        for _, language_name in pairs(server_config.filetypes) do
          local formatters = {}
          for tool_name, tool in pairs(server_config.formatter or {}) do
            if type(tool) == "table" then
              table.insert(formatters, tool_name)
              formatters_settings[tool_name] = tool
            else
              table.insert(formatters, tool)
            end
          end

          formatters_by_ft[language_name] = formatters
        end
      end
      -- formatters_by_ft["_"] = languages.default.formatter

      require("conform").setup({
        formatters_by_ft = formatters_by_ft,
        format_on_save = function(bufnr)
          local errors =
            vim.diagnostic.get(bufnr, { severity = { min = vim.diagnostic.severity.ERROR } })
          local clients = vim.lsp.get_clients({ bufnr = bufnr })
          local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")

          -- fix for omnisharp
          for _, client in pairs(clients) do
            if client.name == "omnisharp" then
              if #errors > 0 then
                return
              end
            end
          end

          local lsp_fallback = true

          if languages[ft] and languages[ft].lsp_fallback then
            lsp_fallback = languages[ft].lsp_fallback
          end

          return {
            timeout_ms = 1500,
            lsp_fallback = lsp_fallback,
          }
        end,
        formatters = formatters_settings,
      })

      -- require("conform").formatters.typos = {
      -- 	stdin = true,
      -- 	args = {
      -- 		"--config",
      -- 		vim.fn.expand("~/.config/typos/typos.toml"),
      -- 		"--write-changes",
      -- 		"-",
      -- 	},
      -- }
    end,
  },
}
