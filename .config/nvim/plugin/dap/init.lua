local loaded = false

local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
  config = vim.deepcopy(config)
  config.args = function()
    local new_args = vim.fn.input("Run with args: ", table.concat(args, " "))
    return vim.split(vim.fn.expand(new_args), " ")
  end
  return config
end

local function load()
  if loaded then
    return
  end
  loaded = true

  vim.pack.add({
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/mfussenegger/nvim-dap",
  })

  require("nvim-dap-virtual-text").setup({ highlight_new_as_changed = true })

  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

  local vscode = require("dap.ext.vscode")
  vscode.json_decode = function(str)
    -- Strip single-line and block comments from JSONC (vscode launch.json)
    str = str:gsub("/%*.-%*/", ""):gsub("//[^\n]*", "")
    return vim.json.decode(str)
  end

  local sign = vim.fn.sign_define
  sign("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "red" })
  sign("DapBreakpointRejected", {
    text = "",
    texthl = "DapBreakpoint",
    linehl = "",
    numhl = "red",
  })
  sign(
    "DapBreakpointCondition",
    { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "red" }
  )
  sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
  sign("DapStopped", { text = "󰧂", texthl = "DapStopped", linehl = "", numhl = "" })
end

local function map(lhs, rhs, desc, mode)
  vim.keymap.set(mode or "n", lhs, function()
    load()
    if type(rhs) == "function" then
      rhs()
    else
      vim.cmd(rhs)
    end
  end, { silent = true, desc = desc })
end

map("<leader>dB", function()
  require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, "Breakpoint Condition")
map("<leader>db", function()
  require("dap").toggle_breakpoint()
end, "Toggle Breakpoint")
map("<leader>da", function()
  require("dap").continue({ before = get_args })
end, "Run with Args")
map("<leader>dC", function()
  require("dap").run_to_cursor()
end, "Run to Cursor")
map("<leader>dg", function()
  require("dap").goto_()
end, "Go to Line (No Execute)")
map("<leader>di", function()
  require("dap").step_into()
end, "Step Into")
map("<leader>dj", function()
  require("dap").down()
end, "Down")
map("<leader>dk", function()
  require("dap").up()
end, "Up")
map("<leader>dl", function()
  require("dap").run_last()
end, "Run Last")
map("<leader>do", function()
  require("dap").step_out()
end, "Step Out")
map("<leader>dO", function()
  require("dap").step_over()
end, "Step Over")
map("<leader>dp", function()
  require("dap").pause()
end, "Pause")
map("<leader>dr", function()
  require("dap").repl.toggle()
end, "Toggle REPL")
map("<leader>ds", function()
  require("dap").session()
end, "Session")
map("<leader>dt", function()
  require("dap").terminate()
end, "Terminate")
map("<leader>dw", function()
  require("dap.ui.widgets").hover()
end, "Widgets")
map("<leader>dI", function()
  require("dap.ui.widgets").hover()
end, "Variables")
map("<leader>dS", function()
  require("dap.ui.widgets").scopes()
end, "Scopes")

map("<F5>", function()
  if vim.fn.filereadable(".vscode/launch.json") == 1 then
    require("dap.ext.vscode").load_launchjs(nil, { coreclr = { "cs" } })
  end
  require("dap").continue()
end, "Continue (F5)")

-- nvim-dap-python
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  once = true,
  callback = function()
    load()
    vim.pack.add({ "https://github.com/mfussenegger/nvim-dap-python" }, { confirm = false })
    require("dap-python").setup("python")

    vim.keymap.set("n", "<leader>dPt", function()
      require("dap-python").test_method()
    end, { silent = true, desc = "Debug Method" })
    vim.keymap.set("n", "<leader>dPc", function()
      require("dap-python").test_class()
    end, { silent = true, desc = "Debug Class" })
  end,
})

-- nvim-jdtls
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  once = true,
  callback = function()
    vim.pack.add({ "https://github.com/mfussenegger/nvim-jdtls" }, { confirm = false })
  end,
})

-- nvim-dap-docker
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dockerfile",
  once = true,
  callback = function()
    load()
    vim.pack.add({ "https://github.com/docker/nvim-dap-docker" }, { confirm = false })
    require("dap-docker").setup()
  end,
})
