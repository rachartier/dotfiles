local map = vim.keymap.set

map("n", "<leader>pv", vim.cmd.Ex)

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Lower the selection" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Raise the selection" })

map("n", "J", "mzJ`z", { desc = "Join line" })
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("x", "<leader>p", [["_dP]])

map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

map({ "n", "v" }, "<leader>d", [["_d]])

map("i", "<C-c>", "<Esc>")

map("n", "Q", "<nop>")
map("n", "<leader>f", vim.lsp.buf.format)

map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

map("n", "<leader>o", "<cmd>!feh <cfile> &<CR>", { silent = true })

if os.getenv("TMUX") then
    map("n", "<M-left>", "<cmd>lua require('tmux').move_left()<cr>", { silent = true })
    map("n", "<M-right>", "<cmd>lua require('tmux').move_right()<cr>", { silent = true })
    map("n", "<M-up>", "<cmd>lua require('tmux').move_top()<cr>", { silent = true })
    map("n", "<M-down>", "<cmd>lua require('tmux').move_bottom()<cr>", { silent = true })
else
    map("n", "<M-left>", "<C-W>h", { silent = true })
    map("n", "<M-right>", "<C-W>l", { silent = true })
    map("n", "<M-up>", "<C-W>k", { silent = true })
    map("n", "<M-down>", "<C-W>j", { silent = true })
end

require("user_plugins.switchbuffer").setup({
    hl_modified = { ctermbg = 232 },
    hl_normal = { ctermbg = 232 },
})

map("n", "<Tab>", '<cmd>lua require("user_plugins.switchbuffer").select_buffers()<cr>')
map("n", "<S-Tab>", '<cmd>lua require("user_plugins.switchbuffer").select_buffers()<cr>')

map("n", "<leader>g", '<cmd>lua require("user_plugins.websearch").websearch_input("google")<cr>')
map("n", "<leader>G", "<cmd>WebSearchInput<cr>")

-- from https://www.reddit.com/r/neovim/comments/13y3thq/whats_a_very_simple_config_change_that_you_cant/
map("i", "<C-BS>", "<Esc>cvb", {})
map("v", "y", "ygv<esc>")
map("n", "p", "p=`]", { silent = true })

-- Don't leave visual mode when changing indent
vim.api.nvim_set_keymap("x", ">", ">gv", { noremap = true })
vim.api.nvim_set_keymap("x", "<", "<gv", { noremap = true })

map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

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
