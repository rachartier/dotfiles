return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<leader>rw",
      function()
        require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
      end,
    },
    {
      "<leader>R",
      function()
        require("grug-far").open({ transient = true })
      end,
    },
  },
  config = function(_, opts)
    require("grug-far").setup(opts)

    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = {
        "grug-far",
      },
      callback = function()
        vim.schedule(function()
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.cursorline = false
        end)
      end,
      desc = "GrugFar settings",
    })
  end,
}
