local map = vim.keymap.set

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Lower the selection" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Raise the selection" })

map("n", "J", "mzJ`z", { desc = "Join line" })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("i", "<C-c>", "<Esc>")

map("n", "<leader>f", vim.lsp.buf.format)

map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

-- map("n", "<leader>o", "<cmd>!feh <cfile> &<CR>", { silent = true })

map("n", "<c-l>", "<c-i>")

if os.getenv("TMUX") then
	map("n", "<M-left>", "<cmd>lua require('tmux').move_left()<cr>", { silent = true })
	map("n", "<M-right>", "<cmd>lua require('tmux').move_right()<cr>", { silent = true })
	map("n", "<M-up>", "<cmd>lua require('tmux').move_top()<cr>", { silent = true })
	map("n", "<M-down>", "<cmd>lua require('tmux').move_bottom()<cr>", { silent = true })

	map("n", "<M-h>", "<cmd>lua require('tmux').move_left()<cr>", { silent = true })
	map("n", "<M-l>", "<cmd>lua require('tmux').move_right()<cr>", { silent = true })
	map("n", "<M-k>", "<cmd>lua require('tmux').move_top()<cr>", { silent = true })
	map("n", "<M-j>", "<cmd>lua require('tmux').move_bottom()<cr>", { silent = true })
	-- else
	--     map("n", "<M-left>", "<C-W>h", { silent = true })
	--     map("n", "<M-right>", "<C-W>l", { silent = true })
	--     map("n", "<M-up>", "<C-W>k", { silent = true })
	--     map("n", "<M-down>", "<C-W>j", { silent = true })
	--
	--     map("n", "<M-h>", "<C-W>h", { silent = true })
	--     map("n", "<M-l>", "<C-W>l", { silent = true })
	--     map("n", "<M-k>", "<C-W>k", { silent = true })
	--     map("n", "<M-j>", "<C-W>j", { silent = true })
end

-- map("n", "<leader>ts", '<cmd>lua require("user_plugins.switchtheme").select_themes()<cr>')

-- map("n", "<leader>g", '<cmd>lua require("user_plugins.websearch").websearch_input("google")<cr>')
-- map("n", "<leader>G", "<cmd>WebSearchInput<cr>")

-- from https://www.reddit.com/r/neovim/comments/13y3thq/whats_a_very_simple_config_change_that_you_cant/
map("i", "<C-BS>", "<Esc>cvb", {})
map("v", "y", "ygv<esc>")
map("n", "p", "p=`]", { silent = true })

-- Don't leave visual mode when changing indent
map("x", ">", ">gv", { noremap = true })
map("x", "<", "<gv", { noremap = true })

map({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

local function indent_empty_line()
	if #vim.fn.getline(".") == 0 then
		return [["_cc]]
	end
end

map("n", "i", function()
	return indent_empty_line() or "i"
end, { expr = true, desc = "Indent on empty line one insert" })

map("n", "a", function()
	return indent_empty_line() or "a"
end, { expr = true, desc = "Indent on empty line one append" })

map("n", "dd", function()
	if vim.api.nvim_get_current_line():match("^%s*$") then
		return '"_dd'
	else
		return "dd"
	end
end, { expr = true, desc = "Smart dd" })

map("n", "<Leader>db", function()
	local curbufnr = vim.api.nvim_get_current_buf()
	local buflist = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(buflist) do
		if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, "bufpersist") ~= 1) then
			vim.cmd("bd " .. tostring(bufnr))
		end
	end
end, { silent = true, desc = "Close unused buffers" })
