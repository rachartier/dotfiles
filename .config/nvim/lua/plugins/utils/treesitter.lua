return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = { ":TSUpdate" },
	event = { "LazyFile" },
	init = function()
		local available_parsers = require("nvim-treesitter.config").get_available()

		vim.api.nvim_create_autocmd("BufRead", {
			callback = function(event)
				local bufnr = event.buf
				local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

				local parser_name = vim.treesitter.language.get_lang(filetype)
				if not parser_name or not vim.tbl_contains(available_parsers, parser_name) then
					return
				end

				local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
				if not parser_installed then
					require("nvim-treesitter").install({ parser_name })
				end

				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				pcall(vim.treesitter.start)
			end,
		})
	end,
	config = function()
		local lang_config = require("config.languages")
		local ensure_installed = {}

		for _, lang in ipairs(lang_config) do
			local filetypes = lang.filetypes or {}
			for _, filetype in ipairs(filetypes) do
				if not vim.tbl_contains(ensure_installed, filetype) then
					table.insert(ensure_installed, filetype)
				end
			end
		end

		-- Only install parsers that aren't already installed
		local already_installed = require("nvim-treesitter.config").installed_parsers()
		local parsers_to_install = {}

		for _, parser in ipairs(ensure_installed) do
			if not vim.tbl_contains(already_installed, parser) then
				table.insert(parsers_to_install, parser)
			end
		end

		-- Install missing parsers if any
		if #parsers_to_install > 0 then
			require("nvim-treesitter").install(parsers_to_install)
		end
	end,
}
