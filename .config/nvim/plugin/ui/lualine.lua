if vim.env.TMUX_NEOGIT_POPUP then
  return
end

vim.g.lualine_laststatus = vim.o.laststatus
if vim.fn.argc(-1) > 0 then
  vim.o.statusline = " "
else
  vim.o.laststatus = 0
end

vim.schedule(function()
  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/folke/sidekick.nvim",
  }, { confirm = false })

  local function get_vlinecount_str()
    local raw_count = vim.fn.line(".") - vim.fn.line("v")
    raw_count = raw_count < 0 and raw_count - 1 or raw_count + 1
    return math.abs(raw_count)
  end

  local function get_scrollbar()
    local sbar_chars = { "▔", "🮂", "🬂", "🮃", "▀", "▄", "▃", "🬭", "▂", "▁" }
    local cur_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor((cur_line - 1) / lines * #sbar_chars) + 1
    return string.rep(sbar_chars[i], 1)
  end

  local colors = require("themes").get_colors()
  local signs = require("config.ui.signs")
  local utils = require("utils")

  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    check_git_workspace = function()
      local filepath = vim.fn.expand("%:p:h")
      local gitdir = vim.fn.finddir(".git", filepath .. ";")
      return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
  }

  local mode_kirby = {
    n = "<(•ᴗ•)>",
    i = "<(•o•)>",
    v = "(v•-•)v",
    [""] = "(v•-•)>",
    V = "(>•-•)>",
  }
  local kirby_default = "(>*-*)>"

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

  local function cond_disable_by_ft()
    local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local ignored = {
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
      "lazyterm",
      "fzf",
    }
    if vim.tbl_contains(ignored, ft) then
      return false
    end
    return conditions.buffer_not_empty()
  end

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
        color = { fg = colors.mauve },
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
        color = { fg = colors.text },
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
        color = { fg = colors.text },
      },
    },
    lualine_c = {},
    lualine_x = {
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
        color = { fg = colors.muted },
        padding = { left = 0, right = 0 },
      },
    },
    lualine_y = {
      {
        "filetype",
        color = { fg = colors.text },
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
        color = { fg = colors.text },
      },
      {
        function()
          return get_scrollbar()
        end,
        color = { fg = colors.muted },
        padding = { left = 1, right = 0 },
      },
    },
    lualine_z = {},
  }

  local theme = require("lualine.themes.auto")
  theme.normal.a = { bg = colors.blue, fg = colors.base, gui = "bold" }
  for _, section in pairs(theme) do
    local bg = utils.darken(colors.surface, 0.65, colors.base)
    if section.b then
      section.b.bg = bg
      section.b.fg = colors.text
    end
    if section.c then
      section.c.bg = bg
      section.c.fg = colors.text
    end
  end

  require("lualine").setup({
    extensions = { "neo-tree", "mason" },
    options = {
      theme = theme,
      disabled_filetypes = { "alpha" },
      icons_enabled = true,
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = sections,
    inactive_sections = sections,
  })
end)
