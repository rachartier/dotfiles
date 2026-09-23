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

map("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "move selection down" })
map("v", "y", "ygv<esc>", { desc = "yank and keep selection" })
map("x", ">", ">gv", { desc = "indent and reselect" })
map("x", "<", "<gv", { desc = "dedent and reselect" })

map("n", "]q", "<cmd>cnext<CR>zz", { silent = true, desc = "next quickfix item" })
map("n", "[q", "<cmd>cprev<CR>zz", { silent = true, desc = "previous quickfix item" })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { silent = true, desc = "next location list item" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { silent = true, desc = "previous location list item" })

map("n", "i", function()
  return indent_empty_line() or "i"
end, { expr = true, desc = "indent on empty line on insert" })

map("n", "a", function()
  return indent_empty_line() or "a"
end, { expr = true, desc = "indent on empty line on append" })

map("n", "dd", function()
  return vim.api.nvim_get_current_line():match("^%s*$") and '"_dd' or "dd"
end, { expr = true, desc = "smart delete line" })

map("n", "<C-p>", "<C-i>", { desc = "go to newer position in jumplist" })
