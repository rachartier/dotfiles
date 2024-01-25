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

-- https://gist.github.com/linguini1/ee91b6d8c196cbd731d10a61447af6a3
vim.api.nvim_create_augroup("py-fstring", { clear = true })
vim.api.nvim_create_autocmd("InsertCharPre", {
	pattern = { "*.py" },
	group = "py-fstring",
	callback = function(opts)
		-- Only run if f-string escape character is typed
		if vim.v.char ~= "{" then
			return
		end

		-- Get node and return early if not in a string
		local node = vim.treesitter.get_node()

		if not node then
			return
		end
		if node:type() ~= "string" then
			node = node:parent()
		end
		if not node or node:type() ~= "string" then
			return
		end

		vim.print(node:type())
		local row, col, _, _ = vim.treesitter.get_node_range(node)

		-- Return early if string is already a format string
		local first_char = vim.api.nvim_buf_get_text(opts.buf, row, col, row, col + 1, {})[1]
		if first_char == "f" then
			return
		end

		-- Otherwise, make the string a format string
		vim.api.nvim_input("<Esc>m'" .. row + 1 .. "gg" .. col + 1 .. "|if<Esc>`'la")
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

local group_name = "MindResizeGroup"
local mind_augroup = vim.api.nvim_create_augroup(group_name, { clear = true })

function ToggleMindWindow()
	local mind_win_found = false
	local windows = vim.api.nvim_list_wins()

	for _, winid in ipairs(windows) do
		local bufid = vim.api.nvim_win_get_buf(winid)
		if vim.api.nvim_buf_get_option(bufid, "filetype") == "mind" then
			mind_win_found = true
			if vim.o.columns < 120 then
				vim.api.nvim_win_close(winid, true)
				require("mind").close()
			end
			break
		end
	end

	if not mind_win_found and vim.o.columns > 120 then
		if require("utils").directory_exists_in_root(".mind") then
			vim.cmd("MindOpenProject")
		else
			vim.cmd("MindOpenMain")
		end

		vim.cmd(":wincmd l")
	end
end

vim.api.nvim_create_autocmd({ "VimResized", "VimEnter" }, {
	group = mind_augroup,
	callback = ToggleMindWindow,
})

vim.api.nvim_create_augroup("AutocloseMindBuffer", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
	group = "AutocloseMindBuffer",
	callback = function()
		local num_visible_windows = 0
		for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
			if vim.api.nvim_win_get_config(win).relative == "" then
				num_visible_windows = num_visible_windows + 1
			end
		end

		if num_visible_windows < 2 then
			if vim.bo.filetype == "mind" then
				vim.cmd("q!")
			end
		end
	end,
})
