local map = vim.keymap.set

local function indent_empty_line()
  if #vim.fn.getline(".") == 0 then
    return [["_cc]]
  end
end

map("n", "<C-d>", "<C-d>zz", { desc = "scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "scroll up and center" })

map("n", "J", "mzJ`z", { desc = "join line" })
map("i", "<C-c>", "<Esc>", { desc = "escape" })
map("i", "<C-BS>", "<Esc>cvb", { desc = "delete word backward" })
map("n", "<leader>f", vim.lsp.buf.format, { desc = "format buffer" })
map("n", "<Leader>r", ":%s/<c-r><c-w>//g<left><left>", { desc = "rename word under cursor" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selection down" })
map("v", "y", "ygv<esc>", { desc = "yank and keep selection" })
map("x", ">", ">gv", { noremap = true, desc = "indent and reselect" })
map("x", "<", "<gv", { noremap = true, desc = "dedent and reselect" })

map("n", "<C-k>", "<cmd>cnext<CR>zz", { desc = "next quickfix item" })
map("n", "<C-j>", "<cmd>cprev<CR>zz", { desc = "previous quickfix item" })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "next location list item" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "previous location list item" })

map("n", "i", function()
  return indent_empty_line() or "i"
end, { expr = true, desc = "indent on empty line on insert" })

map("n", "a", function()
  return indent_empty_line() or "a"
end, { expr = true, desc = "indent on empty line on append" })

map("n", "dd", function()
  if vim.api.nvim_get_current_line():match("^%s*$") then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true, desc = "smart delete line" })

if not vim.env.TMUX then
  map("n", "<M-left>", "<C-W>h", { silent = true, desc = "go to left window" })
  map("n", "<M-right>", "<C-W>l", { silent = true, desc = "go to right window" })
  map("n", "<M-up>", "<C-W>k", { silent = true, desc = "go to upper window" })
  map("n", "<M-down>", "<C-W>j", { silent = true, desc = "go to lower window" })

  map("n", "<M-h>", "<C-W>h", { silent = true, desc = "go to left window" })
  map("n", "<M-l>", "<C-W>l", { silent = true, desc = "go to right window" })
  map("n", "<M-k>", "<C-W>k", { silent = true, desc = "go to upper window" })
  map("n", "<M-j>", "<C-W>j", { silent = true, desc = "go to lower window" })
end

map("n", "<C-p>", "<C-i>", { desc = "go to newer position in jumplist" })
