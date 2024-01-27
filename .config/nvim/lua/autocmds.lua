local function augroup(name)
	return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	command = "checktime",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = augroup("yank_group"),
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "CurSearch",
			timeout = 250,
			priority = 1,
		})
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown", "text" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_delete_trailing_white_space"),
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
})

local id = vim.api.nvim_create_augroup("startup", {
	clear = false,
})

local persistbuffer = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	vim.fn.setbufvar(bufnr, "bufpersist", 1)
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
	group = id,
	pattern = { "*" },
	callback = function()
		vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
			buffer = 0,
			once = true,
			callback = function()
				persistbuffer()
			end,
		})
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "AlphaReady",
	command = "set showtabline=0 | set laststatus=0",
})

vim.cmd([[
    augroup _pico
    autocmd!
    autocmd BufRead,BufEnter *.p8 set filetype=pico8
    augroup end
]])

vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Open file at the last position it was edited earlier",
	group = augroup("misc"),
	pattern = "*",
	command = 'silent! normal! g`"zv',
})
