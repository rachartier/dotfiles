local loaded = false

local function load()
  if loaded then return end
  loaded = true

  vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" }, { confirm = false })
  require("grug-far").setup()

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "grug-far",
    callback = function()
      vim.schedule(function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.cursorline = false
      end)
    end,
    desc = "grug-far settings",
  })
end

local function create_cmd(name, fn)
  vim.api.nvim_create_user_command(name, function(info)
    load()
    vim.api.nvim_del_user_command(name)
    fn(info)
  end, { nargs = "?" })
end

create_cmd("GrugFar", function() require("grug-far").open({ transient = true }) end)

vim.keymap.set("n", "<leader>rw", function()
  load()
  require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { silent = true, desc = "search and replace word under cursor" })

vim.keymap.set("n", "<leader>R", function()
  load()
  require("grug-far").open({ transient = true })
end, { silent = true, desc = "search and replace" })
