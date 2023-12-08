if vim.b.current_syntax ~= nil then
	vim.b.current_syntax = nil
end

local buf = vim.api.nvim_get_current_buf()
-- Use vim.schedule to avoid freezing neovim
-- when reloading markdown files
vim.schedule(function()
	vim.api.nvim_buf_call(buf, function()
		-- Apply treesitter highlighting for better
		-- embedded code block syntax highlighting
		pcall(vim.treesitter.start, buf, "markdown")
		-- Apply regex syntax rules to get math conceal
		-- provided by vimtex and url conceal
		vim.cmd.runtime("syntax/mkd.vim")
		vim.b[buf].current_syntax = "mkd"
	end)
end)
