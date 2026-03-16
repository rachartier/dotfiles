vim.pack.add({
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/nvim-neotest/neotest-python",
  "https://github.com/nvim-neotest/neotest",
}, { confirm = false })

local loaded = false

local function load()
  if loaded then
    return
  end
  loaded = true

  require("neotest").setup({
    adapters = {
      require("neotest-python")({ runner = "pytest" }),
    },
    is_test_file = function(file_path)
      return file_path:match("test_") or file_path:match("_test") or file_path:match("tests/")
    end,
  })
end

local function map(lhs, rhs, desc)
  vim.keymap.set("n", lhs, function()
    load()
    rhs()
  end, { silent = true, desc = desc })
end

map("<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, "Run File (Neotest)")
map("<leader>tR", function()
  require("neotest").run.run(vim.uv.cwd())
end, "Run All Test Files (Neotest)")
map("<leader>tr", function()
  require("neotest").run.run()
end, "Run Nearest (Neotest)")
map("<leader>tl", function()
  require("neotest").run.run_last()
end, "Run Last (Neotest)")
map("<leader>ts", function()
  require("neotest").summary.toggle()
end, "Toggle Summary (Neotest)")
map("<leader>to", function()
  require("neotest").output.open({ enter = true, auto_close = true })
end, "Show Output (Neotest)")
map("<leader>tO", function()
  require("neotest").output_panel.toggle()
end, "Toggle Output Panel (Neotest)")
map("<leader>tS", function()
  require("neotest").run.stop()
end, "Stop (Neotest)")
map("<leader>tw", function()
  require("neotest").watch.toggle(vim.fn.expand("%"))
end, "Toggle Watch (Neotest)")
