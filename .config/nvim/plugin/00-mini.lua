vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" }, { confirm = false })

package.preload["nvim-web-devicons"] = function()
  require("mini.icons").mock_nvim_web_devicons()
  return package.loaded["nvim-web-devicons"]
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "mason", "dapui_stacks" },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
  desc = "disable mini.indentscope",
})

-- mini.starter sets its filetype with :noautocmd, so FileType never fires for it.
vim.api.nvim_create_autocmd("User", {
  pattern = "MiniStarterOpened",
  callback = function()
    vim.b.miniindentscope_disable = true
    vim.b.minipairs_disable = true
  end,
  desc = "disable mini.indentscope and mini.pairs on starter",
})

require("plugins.utils.mini.base16").setup()

vim.schedule(function()
  require("mini.surround").setup()
  require("mini.align").setup()
  require("mini.jump2d").setup({})

  require("mini.splitjoin").setup({
    mappings = { toggle = "gS", split = "", join = "" },
  })

  require("mini.indentscope").setup({
    draw = {
      delay = 0,
      animation = require("mini.indentscope").gen_animation.none(),
    },
    options = {
      indent_at_cursor = true,
      try_as_border = true,
      border = "top",
    },
  })

  local ai = require("mini.ai")
  ai.setup({
    n_lines = 500,
    custom_textobjects = {
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
      d = { "%f[%d]%d+" },
      e = {
        {
          "%u[%l%d]+%f[^%l%d]",
          "%f[%S][%l%d]+%f[^%l%d]",
          "%f[%P][%l%d]+%f[^%l%d]",
          "^[%l%d]+%f[^%l%d]",
        },
        "^().*()$",
      },
      u = ai.gen_spec.function_call(),
      U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
    },
  })

  require("mini.icons").setup({
    file = {
      ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
    },
    filetype = {
      json = { glyph = "" },
      jsonc = { glyph = "" },
      dotenv = { glyph = "", hl = "MiniIconsYellow" },
    },
    extension = {
      conf = { glyph = "", hl = "MiniIconsBlue" },
    },
  })

  local mini_pairs = require("mini.pairs")
  mini_pairs.setup({
    modes = { insert = true, command = false, terminal = false },
  })

  -- Python: typing { after f" or f' creates {} pair (for f-strings)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
      mini_pairs.map_buf(0, "i", "{", { action = "open", pair = "{}", neigh_pattern = "[\"']." })
    end,
  })

  -- C#: typing { after $" creates {} pair (for interpolated strings)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
      mini_pairs.map_buf(0, "i", "{", { action = "open", pair = "{}", neigh_pattern = '".' })
    end,
  })

  require("plugins.utils.mini.picker").setup()

  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      { mode = { "n", "x" }, keys = "<Leader>" },
    },
    clues = {
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
    },
    window = {
      config = {},
      delay = 150,
      scroll_down = "<C-d>",
      scroll_up = "<C-u>",
    },
  })
end)

require("plugins.utils.mini.starter").setup()
