local function get_vlinecount_str()
  local raw_count = vim.fn.line(".") - vim.fn.line("v")
  raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1

  return math.abs(raw_count)
end

local function get_scrollbar()
  local sbar_chars = {
    "▔",
    "🮂",
    "🬂",
    "🮃",
    "▀",
    "▄",
    "▃",
    "🬭",
    "▂",
    "▁",
  }

  local cur_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_line_count(0)

  local i = math.floor((cur_line - 1) / lines * #sbar_chars) + 1
  local sbar = string.rep(sbar_chars[i], 1)

  return sbar
end

local function get_lualine_colors()
  local c = require("themes").get_colors()

  local lualine_colors = {
    bg = c.surface0,
    fg = c.subtext0,
    surface0 = c.surface0,
    yellow = c.yellow,
    flamingo = c.flamingo,
    cyan = c.sapphire,
    darkblue = c.mantle,
    green = c.green,
    orange = c.peach,
    violet = c.lavender,
    mauve = c.mauve,
    blue = c.blue,
    red = c.red,
  }

  return vim.tbl_extend("force", lualine_colors, c)
end

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}
local function cond_disable_by_ft()
  local not_empty = conditions.buffer_not_empty()
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })

  local filetype_to_ignore = {
    "terminal",
    "help",
    "alpha",
    "dashboard",
    "neo-tree",
    "Trouble",
    "trouble",
    "lazy",
    "mason",
    "notify",
    "toggleterm",
    "dapui_stacks",
    "toggleterm",
    "lazyterm",
    "fzf",
  }

  if vim.tbl_contains(filetype_to_ignore, filetype) then
    return false
  end

  return not_empty
end

return {
  "nvim-lualine/lualine.nvim",
  event = "LazyFile",
  enabled = vim.env.TMUX_NEOGIT_POPUP == nil,
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = " "
    else
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    local signs = require("config.ui.signs")
    local colors = get_lualine_colors()

    local kirby_default = "(>*-*)>"
    local mode_kirby = {
      n = "<(•ᴗ•)>",
      i = "<(•o•)>",
      v = "(v•-•)v",
      [""] = "(v•-•)>",
      V = "(>•-•)>",
      c = kirby_default,
      no = "<(•ᴗ•)>",
      s = kirby_default,
      S = kirby_default,
      [""] = kirby_default,
      ic = kirby_default,
      R = kirby_default,
      Rv = kirby_default,
      cv = "<(•ᴗ•)>",
      ce = "<(•ᴗ•)>",
      r = kirby_default,
      rm = kirby_default,
      ["r?"] = kirby_default,
      ["!"] = "<(•ᴗ•)>",
      t = "<(•ᴗ•)>",
    }

    local is_inside_docker = false

    local Job = require("plenary.job")
    Job:new({
      command = os.getenv("HOME") .. "/.config/scripts/is_inside_docker.sh",
      on_stdout = function(_, data)
        if data == "1" then
          is_inside_docker = true
        end
      end,
    }):start()

    local sections = {
      lualine_a = {
        {
          "mode",
          fmt = function()
            return mode_kirby[vim.fn.mode()] or vim.api.nvim_get_mode().mode
          end,
          separator = { right = "" },
          padding = { left = 1, right = 1 },
        },
      },
      lualine_b = {
        {
          "branch",
          icon = signs.git.branch,
          color = { fg = colors.violet },
          padding = { left = 4, right = 2 },
        },
        {
          function()
            local msg = " No Active Lsp"
            local text_clients = ""

            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if next(clients) == nil then
              return msg
            end
            for _, client in ipairs(clients) do
              if client.name ~= "copilot" then
                text_clients = text_clients .. client.name .. ", "
              end
            end
            if text_clients ~= "" then
              return text_clients:sub(1, -3)
            end
            return msg
          end,
          icon = "",
          color = { fg = colors.subtext0 },
          padding = { left = conditions.check_git_workspace() and 2 or 4, right = 2 },
        },
        {
          "diagnostics",
          sources = { "nvim_lsp" },
          symbols = {
            ok = signs.full_diagnostic.ok .. " ",
            error = signs.full_diagnostic.error .. " ",
            warn = signs.full_diagnostic.warning .. " ",
            hint = signs.full_diagnostic.hint .. " ",
            info = signs.full_diagnostic.info .. " ",
          },
          colored = true,
          padding = { left = 2, right = 0 },
          color = { fg = colors.subtext0 },
        },
      },
      lualine_c = {},
      lualine_x = {
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          padding = { left = 1, right = 2 },
          color = { fg = colors.green },
        },
        {
          function()
            return " "
          end,
          color = function()
            local status = require("sidekick.status").get()
            if status then
              return status.kind == "Error" and { fg = colors.red }
                or status.busy and { fg = colors.yellow }
                or { fg = colors.text }
            end
          end,
          cond = function()
            local status = require("sidekick.status")
            return status.get() ~= nil
          end,
        },
        {
          function()
            if is_inside_docker then
              return " "
            end
            return ""
          end,
          color = { fg = colors.blue },
          padding = { left = 1, right = 1 },
        },
        {
          function()
            return " | "
          end,
          color = { fg = colors.surface2 },
          padding = { left = 0, right = 0 },
        },
      },
      lualine_y = {
        {
          "filetype",
          color = { fg = colors.subtext0 },
          separator = { right = "", left = "" },
          cond = cond_disable_by_ft,
          icon_only = false,
          colored = true,
          padding = { left = 2, right = 2 },
        },
        {
          function()
            local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
            local lines = vim.api.nvim_buf_line_count(0)

            local wc_table = vim.fn.wordcount()

            if wc_table.visual_words and wc_table.visual_chars then
              return table.concat({
                "‹› ",
                get_vlinecount_str(),
                " lines  ",
                wc_table.visual_words,
                " words  ",
                wc_table.visual_chars,
                " chars ",
              })
            end

            if vim.tbl_contains(vim.g.noncode_ft, ft) then
              return table.concat({
                lines,
                " lines  ",
                wc_table.words,
                " words ",
              })
            end

            return table.concat({
              string.format("%0" .. string.len(tostring(lines)) .. "d", vim.fn.line(".")),
              "/",
              tostring(lines),
              " ",
              string.format("%03d", vim.fn.col(".")),
            })
          end,
          padding = { left = 2, right = 1 },
          color = { fg = colors.subtext0 },
        },
        {
          function()
            return get_scrollbar()
          end,
          color = { fg = colors.surface2 },
          padding = { left = 1, right = 0 },
        },
      },
      lualine_z = {},
    }

    local theme = require("lualine.themes.auto")
    local utils = require("utils")

    for _, section in pairs(theme) do
      if section.b then
        section.b.bg = utils.darken(colors.surface0, 0.65, colors.base)
      end
      if section.c then
        section.c.bg = utils.darken(colors.surface0, 0.65, colors.base)
      end
    end

    local config = {
      extensions = {
        "lazy",
        "neo-tree",
        "mason",
      },
      options = {
        theme = theme,
        disabled_filetypes = { "alpha", "snacks_dashboard" },
        icons_enabled = true,
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = sections,
      inactive_sections = sections,
    }

    return config
  end,

  config = function(_, opts)
    require("lualine").setup(opts)
  end,
}
