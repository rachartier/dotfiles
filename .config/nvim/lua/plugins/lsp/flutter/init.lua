return {
  "akinsho/flutter-tools.nvim",
  ft = { "dart" },
  cond = vim.g.dotfile_config_type ~= "minimal",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {},
  config = function(_, opts)
    vim.defer_fn(function()
      require("flutter-tools").setup({
        debugger = { -- integrate with nvim dap + install dart code debugger
          enabled = true,
          run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
          -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
          -- see |:help dap.set_exception_breakpoints()| for more info
          exception_breakpoints = {},
        },
        flutter_path = vim.fn.exepath("flutter") ~= "" and vim.fn.exepath("flutter")
          or "/opt/flutter/bin/flutter",
      })
    end, 50)
  end,
}
