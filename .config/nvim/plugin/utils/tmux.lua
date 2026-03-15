vim.g.tmux_navigator_no_mappings = 1

vim.pack.add({ "https://github.com/christoomey/vim-tmux-navigator" }, { confirm = false })

vim.keymap.set("n", "<M-Left>",  "<cmd>TmuxNavigateLeft<cr>",     { silent = true, desc = "tmux navigate left" })
vim.keymap.set("n", "<M-Down>",  "<cmd>TmuxNavigateDown<cr>",     { silent = true, desc = "tmux navigate down" })
vim.keymap.set("n", "<M-Up>",    "<cmd>TmuxNavigateUp<cr>",       { silent = true, desc = "tmux navigate up" })
vim.keymap.set("n", "<M-Right>", "<cmd>TmuxNavigateRight<cr>",    { silent = true, desc = "tmux navigate right" })
vim.keymap.set("n", "<M-h>",     "<cmd>TmuxNavigateLeft<cr>",     { silent = true, desc = "tmux navigate left" })
vim.keymap.set("n", "<M-j>",     "<cmd>TmuxNavigateDown<cr>",     { silent = true, desc = "tmux navigate down" })
vim.keymap.set("n", "<M-k>",     "<cmd>TmuxNavigateUp<cr>",       { silent = true, desc = "tmux navigate up" })
vim.keymap.set("n", "<M-l>",     "<cmd>TmuxNavigateRight<cr>",    { silent = true, desc = "tmux navigate right" })
vim.keymap.set("n", "<C-\\>",    "<cmd>TmuxNavigatePrevious<cr>", { silent = true, desc = "tmux navigate previous" })
