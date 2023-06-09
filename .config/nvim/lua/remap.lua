vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Lower the selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Raise the selection" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>o", "<cmd>!feh <cfile> &<CR>", { silent = true })

if os.getenv("TMUX") then
    vim.keymap.set("n", "<M-left>", "<cmd>lua require('tmux').move_left()<cr>", { silent = true })
    vim.keymap.set("n", "<M-right>", "<cmd>lua require('tmux').move_right()<cr>", { silent = true })
    vim.keymap.set("n", "<M-up>", "<cmd>lua require('tmux').move_top()<cr>", { silent = true })
    vim.keymap.set("n", "<M-down>", "<cmd>lua require('tmux').move_bottom()<cr>", { silent = true })
else
    vim.keymap.set("n", "<M-left>", "<C-W>h", { silent = true })
    vim.keymap.set("n", "<M-right>", "<C-W>l", { silent = true })
    vim.keymap.set("n", "<M-up>", "<C-W>k", { silent = true })
    vim.keymap.set("n", "<M-down>", "<C-W>j", { silent = true })
end

vim.keymap.set("n", "<leader>g", '<cmd>lua require("user_plugins.websearch").websearch_input("google")<cr>')
vim.keymap.set("n", "<leader>G", "<cmd>WebSearchInput<cr>")

-- from https://www.reddit.com/r/neovim/comments/13y3thq/whats_a_very_simple_config_change_that_you_cant/
vim.keymap.set("i", "<C-BS>", "<Esc>cvb", {})
vim.keymap.set("v", "y", "ygv<esc>")
vim.keymap.set("n", "p", "p=`]", { silent = true })

-- Don't leave visual mode when changing indent
vim.api.nvim_set_keymap("x", ">", ">gv", { noremap = true })
vim.api.nvim_set_keymap("x", "<", "<gv", { noremap = true })
