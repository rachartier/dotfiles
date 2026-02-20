local HEADER_LINES = {
  "███┐   ██┐███████┐ ██████┐ ██┐   ██┐██┐███┐   ███┐",
  "████┐  ██│██┌────┘██┌───██┐██│   ██│██│████┐ ████│",
  "██┌██┐ ██│█████┐  ██│   ██│██│   ██│██│██┌████┌██│",
  "██│└██┐██│██┌──┘  ██│   ██│└██┐ ██┌┘██│██│└██┌┘██│",
  "██│ └████│███████┐└██████┌┘ └████┌┘ ██│██│ └─┘ ██│",
  "└─┘  └───┘└──────┘ └─────┘   └───┘  └─┘└─┘     └─┘",
}

local header_width = vim.fn.strdisplaywidth(HEADER_LINES[1])

local function center_text(text)
  local padding = math.floor((header_width - vim.fn.strdisplaywidth(text)) / 2)
  return string.rep(" ", padding) .. text
end

local function build_header()
  local v = vim.version()
  local version_str = string.format(
    "󱝁 v%d.%d.%d (%s)",
    v.major,
    v.minor,
    v.patch,
    v.prerelease and "Nightly" or "Stable"
  )
  return table.concat(HEADER_LINES, "\n") .. "\n" .. center_text(version_str)
end

local function build_footer()
  local stats = require("lazy").stats()
  local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
  return center_text(
    string.format("  %d/%d plugins loaded in %.2fms", stats.loaded, stats.count, ms)
  )
end

local function hook_center_items(content)
  local items, max_width = {}, 0

  for i, line in ipairs(content) do
    local width, is_item = 0, false
    for _, unit in ipairs(line) do
      width = width + vim.fn.strdisplaywidth(unit.string)
      is_item = is_item or unit.type == "item"
    end
    if is_item then
      max_width = math.max(max_width, width)
      items[#items + 1] = { idx = i, width = width }
    end
  end

  local left_pad = math.floor((header_width - max_width) / 2)
  for _, item in ipairs(items) do
    local line = content[item.idx]
    local right_pad = max_width - item.width
    if right_pad > 0 then
      line[#line + 1] = { string = string.rep(" ", right_pad), type = "empty" }
    end
    if left_pad > 0 then
      table.insert(line, 1, { string = string.rep(" ", left_pad), type = "empty" })
    end
  end

  return content
end

local M = {}

function M.setup()
  local starter = require("mini.starter")

  starter.setup({
    evaluate_single = true,
    header = build_header(),
    footer = "",
    autoopen = true,
    items = {
      { name = "New File", action = "ene | startinsert", section = "", keys = "n" },
      { name = "Lazy", action = "Lazy", section = "", keys = "l" },
      { name = "Quit", action = "qa", section = "", keys = "q" },
    },
    content_hooks = {
      starter.gen_hook.adding_bullet(" "),
      hook_center_items,
      starter.gen_hook.aligning("center", "center"),
    },
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ministarter",
    callback = function()
      vim.b.miniindentscope_disable = true
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyVimStarted",
    callback = function()
      if vim.bo.filetype == "ministarter" then
        starter.config.footer = build_footer()
        pcall(starter.refresh)
      end
    end,
  })
end

return M
