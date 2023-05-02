vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {desc="Lower the selection"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {desc="Raise the selection"})

vim.keymap.set("n", "J", "mzJ`z", {desc="Join line"})
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

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

vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { silent = true })
vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<cr>", { silent = true })

vim.keymap.set("n", "<leader>o", "<cmd>!feh <cfile> &<CR>", { silent = true })


vim.keymap.set("n", "C-left", "<cmd>lua require('tmux').move_left()<cr>", { silent = true })
vim.keymap.set("n", "C-right", "<cmd>lua require('tmux').move_right()<cr>", { silent = true })
vim.keymap.set("n", "C-up", "<cmd>lua require('tmux').move_top()<cr>", { silent = true })
vim.keymap.set("n", "C-down", "<cmd>lua require('tmux').move_bottom()<cr>", { silent = true })

vim.keymap.set("n", "<leader>te", "<cmd>NvimTreeToggle<CR>", { silent = true })
