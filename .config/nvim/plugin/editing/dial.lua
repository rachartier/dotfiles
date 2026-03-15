local loaded = false

local function load()
  if loaded then return end
  loaded = true
  vim.pack.add({ "https://github.com/monaqa/dial.nvim" }, { confirm = false })

  local augend = require("dial.augend")

  local logical_alias = augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true })

  local ordinal_numbers = augend.constant.new({
    elements = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" },
    word = false, cyclic = true,
  })

  local weekdays = augend.constant.new({
    elements = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
    word = true, cyclic = true,
  })

  local months = augend.constant.new({
    elements = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" },
    word = true, cyclic = true,
  })

  local capitalized_boolean = augend.constant.new({ elements = { "True", "False" }, word = true, cyclic = true })
  local checkboxes         = augend.constant.new({ elements = { "[-]", "[ ]", "[x]", "[/]" }, word = false, cyclic = true })
  local checkboxes_thumbs  = augend.constant.new({ elements = { "[y]", "[n]" }, word = false, cyclic = true })
  local checkboxes_others  = augend.constant.new({ elements = { "[f]", "[s]", "[*]", "[!]" }, word = false, cyclic = true })
  local checkboxes_attr    = augend.constant.new({ elements = { "[?]", "[i]" }, word = false, cyclic = true })

  local groups = {
    default = {
      augend.integer.alias.decimal,
      augend.integer.alias.decimal_int,
      augend.integer.alias.hex,
      augend.date.alias["%Y/%m/%d"],
      ordinal_numbers, weekdays, months, capitalized_boolean,
      augend.constant.alias.bool, logical_alias,
    },
    typescript = {
      augend.integer.alias.decimal, augend.constant.alias.bool, logical_alias,
      augend.constant.new({ elements = { "let", "const" } }),
    },
    yaml    = { augend.integer.alias.decimal, augend.constant.alias.bool },
    css     = { augend.integer.alias.decimal, augend.hexcolor.new({ case = "lower" }), augend.hexcolor.new({ case = "upper" }) },
    markdown = { augend.misc.alias.markdown_header, checkboxes, checkboxes_thumbs, checkboxes_others, checkboxes_attr },
    json    = { augend.semver.alias.semver },
    lua     = { augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }) },
    python  = { augend.constant.new({ elements = { "and", "or" } }) },
  }

  for name, group in pairs(groups) do
    if name ~= "default" then
      vim.list_extend(group, groups.default)
    end
  end

  require("dial.config").augends:register_group(groups)

  vim.g.dials_by_ft = {
    css = "css", javascript = "typescript", javascriptreact = "typescript",
    json = "json", lua = "lua", markdown = "markdown", python = "python",
    sass = "css", scss = "css", typescript = "typescript",
    typescriptreact = "typescript", yaml = "yaml",
  }
end

local function dial(increment, g)
  load()
  local mode = vim.fn.mode(true)
  local is_visual = mode == "v" or mode == "V" or mode == "\22"
  local func = (increment and "inc" or "dec") .. (g and "_g" or "_") .. (is_visual and "visual" or "normal")
  local group = vim.g.dials_by_ft[vim.bo.filetype] or "default"
  return require("dial.map")[func](group)
end

vim.keymap.set({ "n", "v" }, "<C-a>",  function() return dial(true,  false) end, { expr = true, desc = "Increment" })
vim.keymap.set({ "n", "v" }, "<C-x>",  function() return dial(false, false) end, { expr = true, desc = "Decrement" })
vim.keymap.set({ "n", "v" }, "g<C-a>", function() return dial(true,  true)  end, { expr = true, desc = "Increment" })
vim.keymap.set({ "n", "v" }, "g<C-x>", function() return dial(false, true)  end, { expr = true, desc = "Decrement" })
