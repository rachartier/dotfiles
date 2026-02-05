local keywords = {
  FIX = { pattern = "ERROR|FIX|FIXME|BUG|ISSUE", color = "red" },
  TODO = { pattern = "TODO", color = "blue" },
  HACK = { pattern = "HACK|WORKAROUND", color = "peach" },
  WARN = { pattern = "WARN|WARNING|XXX", color = "yellow" },
  PERF = { pattern = "PERF|OPTIM|PERFORMANCE|OPTIMIZE", color = "green" },
  NOTE = { pattern = "NOTE|INFO", color = "teal" },
  TEST = { pattern = "TEST|TESTING|PASSED|FAILED", color = "mauve" },
}

local function setup_highlights()
  local colors = require("theme").get_colors()
  for name, kw in pairs(keywords) do
    vim.api.nvim_set_hl(0, "Todo" .. name, { fg = colors[kw.color], bold = true })
  end
end

local function apply_matches()
  for name, kw in pairs(keywords) do
    local pattern = [[\v\C<(]] .. kw.pattern .. [[)(\s*\(.*\))?:]]
    vim.fn.matchadd("Todo" .. name, pattern, 10, -1, { window = 0 })
  end
end

setup_highlights()

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  callback = function()
    vim.fn.clearmatches()
    apply_matches()
  end,
  desc = "highlight todo keywords",
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_highlights,
  desc = "reapply todo highlights on colorscheme change",
})

vim.keymap.set("n", "<leader>ft", function()
  require("fzf-lua").grep({ search = "TODO|FIXME|FIX|HACK|WARN|NOTE|PERF|TEST", no_esc = true })
end, { desc = "Todo" })

vim.keymap.set("n", "<leader>fT", function()
  require("fzf-lua").grep({ search = "TODO|FIX|FIXME", no_esc = true })
end, { desc = "Todo/Fix/Fixme" })
