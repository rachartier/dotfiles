local M = {}

local function startup()
  M.lazy_stats = M.lazy_stats and M.lazy_stats.startuptime > 0 and M.lazy_stats
    or require("lazy.stats").stats()
  local ms = (math.floor(M.lazy_stats.startuptime * 100 + 0.5) / 100)
  return {
    align = "center",
    text = {
      { "  Loaded ", hl = "footer" },
      { M.lazy_stats.loaded .. "/" .. M.lazy_stats.count, hl = "special" },
      { " plugins in ", hl = "footer" },
      { ms .. "ms", hl = "special" },
    },
  }
end

return {
  "folke/snacks.nvim",
  priority = 9999,
  lazy = false,
    -- stylua: ignore start
    keys = {
      -- -- Top Pickers & Explorer
      -- { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      -- { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- -- find
      -- { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      -- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      -- -- git
      -- { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      -- { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      -- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      -- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      -- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      -- { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- -- Grep
      -- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      -- { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      -- { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      -- { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- -- search
      -- { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      -- { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      -- { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      -- { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      -- { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      -- { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      -- { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      -- { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      -- { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      -- { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      -- { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      -- { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      -- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      -- { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      -- { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      -- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      -- { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      -- { "<leader>fl", function() Snacks.picker.resume() end, desc = "Resume" },
      -- { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
      -- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- -- LSP
      -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      -- { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      -- { "fr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      -- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      -- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
      -- -- GH
      -- { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      -- { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      -- { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      -- { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
      -- { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      -- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      --   {
      --       "<leader>ff",
      --       function()
      --           Snacks.picker.files({
      --               exclude = { "node_modules", ".git", ".cache", ".local", ".npm", ".yarn", "__pycache__", ".venv" },
      --           })
      --       end,
      --       desc = "Find Files"
      --   },
      { "<leader>go", function() Snacks.gitbrowse.open() end, desc = "Browse Git Repository" },
    },
  -- stylua: ignore end
  opts = {
    styles = {
      notification = {
        border = require("config.ui.border").default_border,
        wo = {
          wrap = true,
        },
      },
    },
    notifier = require("plugins.utils.snacks.notifier"),
    dashboard = require("plugins.utils.snacks.dashboard"),
    indent = require("plugins.utils.snacks.indent"),
    -- picker = require("plugins.utils.snacks.picker"),
    picker = { enabled = false },
    image = { enabled = false },
    gitbrowse = { enabled = true },
    -- notify = { enabled = true },
    toggle = { enabled = true },
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    rename = { enabled = true },
    -- statuscolumn = { enabled = true },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command
      end,
    })
  end,
  config = function(_, opts)
    Snacks.dashboard.sections.startup = startup
    require("snacks").setup(opts)

    Snacks.toggle.profiler():map("<leader>pp")
    Snacks.toggle.profiler_highlights():map("<leader>ph")

    if vim.env.PROF then
      local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
      vim.opt.rtp:append(snacks)
      require("snacks.profiler").startup({
        startup = {
          -- event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
          -- event = "UIEnter",
          event = "LspAttach",
        },
      })
    end

    if opts.scroll then
      vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
        pattern = "/",
        callback = function(ev)
          if ev.event == "CmdlineEnter" then
            Snacks.scroll.disable()
          else
            Snacks.scroll.enable()
          end
        end,
      })
    end
  end,
}
