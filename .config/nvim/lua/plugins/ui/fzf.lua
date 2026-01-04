local signs = require("config.ui.signs")

return {
  "ibhagwan/fzf-lua",
  dependencies = {
    "elanmed/fzf-lua-frecency.nvim",
  },
  event = { "VeryLazy" },
  command = "FzfLua",
  -- lazy = vim.fn.argc(-1) > 0,
  keys = {
    -- stylua: ignore start
    -- Files & Buffers
    { "<leader>ff", function() require("fzf-lua").files({
      winopts = {
        preview = {
          hidden = vim.o.columns < 120
        },
      },
    }) end, desc = "find files" },
    { "<leader>fp", function() require("fzf-lua").global() end, desc = "find globals" },
    { "<leader>fb", function() require("fzf-lua").buffers() end, desc = "find buffers" },
    { "<leader>fB", function() require("fzf-lua").builtin() end, desc = "show fzf builtins" },
    { "<leader>fc", function() require("fzf-lua").files({ cwd = vim.fn.stdpath("config") }) end, desc = "find config files" },
    { "<leader>fG", function() require("fzf-lua").git_files() end, desc = "find git files" },
    { "<leader>fo", function() require("fzf-lua").oldfiles() end, desc = "recent files" },
    { "<leader>fT", function() require("fzf-lua").tabs() end, desc = "tabs" },
    { "<leader>fl", function() require("fzf-lua").resume() end, desc = "resume last picker" },

    -- Grep & Search
    { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "grep words inside files" },
    { "<leader>fw", function() require("fzf-lua").grep_cword() end, desc = "grep string under cursor" },
    { "<leader>fw", function() require("fzf-lua").grep_visual() end, desc = "grep visual selection", mode = "x" },
    { "<leader>ft", function() require("fzf-lua").grep({ search = "TODO|HACK|PERF|NOTE|FIX|WARN", no_esc = true }) end, desc = "Search all todos" },
    { "<leader>sb", function() require("fzf-lua").lines() end, desc = "buffer lines" },
    { "<leader>sB", function() require("fzf-lua").blines() end, desc = "current buffer lines" },
    { "<leader>sg", function() require("fzf-lua").lgrep_curbuf() end, desc = "live grep current buffer" },

    -- LSP
    { "<leader>fr", function() require("fzf-lua").lsp_references() end, desc = "find all lsp references" },
    { "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, desc = "Search document symbols" },
    { "<leader>fS", function() require("fzf-lua").lsp_workspace_symbols() end, desc = "Search workspace symbols" },
    { "<leader>fL", function() require("fzf-lua").lsp_live_workspace_symbols() end, desc = "Live workspace symbols" },
    { "<leader>sF", function() require("fzf-lua").lsp_finder() end, desc = "LSP finder (all locations)" },
    { "<leader>st", function() require("fzf-lua").treesitter() end, desc = "treesitter symbols" },
    { "gd", function() require("fzf-lua").lsp_definitions() end, desc = "goto definition" },
    { "gD", function() require("fzf-lua").lsp_declarations() end, desc = "goto declaration" },
    { "gI", function() require("fzf-lua").lsp_implementations() end, desc = "goto implementation" },
    { "gy", function() require("fzf-lua").lsp_typedefs() end, desc = "goto type definition" },
    { "gai", function() require("fzf-lua").lsp_incoming_calls() end, desc = "incoming calls" },
    { "gao", function() require("fzf-lua").lsp_outgoing_calls() end, desc = "outgoing calls" },

    -- Diagnostics
    { "<leader>fd", function() require("fzf-lua").diagnostics_workspace() end, desc = "workspace diagnostics" },
    { "<leader>sD", function() require("fzf-lua").diagnostics_document() end, desc = "buffer diagnostics" },

    -- Git
    { "<leader>gb", function() require("fzf-lua").git_branches() end, desc = "git branches" },
    { "<leader>gl", function() require("fzf-lua").git_commits() end, desc = "git log" },
    { "<leader>gf", function() require("fzf-lua").git_bcommits() end, desc = "git log file" },
    { "<leader>gs", function() require("fzf-lua").git_status() end, desc = "git status" },
    { "<leader>gS", function() require("fzf-lua").git_stash() end, desc = "git stash" },
    { "<leader>gd", function() require("fzf-lua").git_diff() end, desc = "git diff" },
    { "<leader>gB", function() require("fzf-lua").git_blame() end, desc = "git blame" },
    { "<leader>gt", function() require("fzf-lua").git_tags() end, desc = "git tags" },
    { "<leader>gw", function() require("fzf-lua").git_worktrees() end, desc = "git worktrees" },

    -- Neovim Utilities
    { "<leader>:", function() require("fzf-lua").command_history() end, desc = "command history" },
    { '<leader>s"', function() require("fzf-lua").registers() end, desc = "registers" },
    { "<leader>s/", function() require("fzf-lua").search_history() end, desc = "search history" },
    { "<leader>sa", function() require("fzf-lua").autocmds() end, desc = "autocmds" },
    { "<leader>sh", function() require("fzf-lua").helptags() end, desc = "help pages" },
    { "<leader>sj", function() require("fzf-lua").jumps() end, desc = "jumps" },
    { "<leader>sc", function() require("fzf-lua").changes() end, desc = "changes" },
    { "<leader>sl", function() require("fzf-lua").loclist() end, desc = "location list" },
    { "<leader>sM", function() require("fzf-lua").manpages() end, desc = "man pages" },
    { "<leader>sq", function() require("fzf-lua").quickfix() end, desc = "quickfix list" },
    { "<leader>sr", function() require("fzf-lua").tagstack() end, desc = "tag stack" },
    { "<leader>so", function() require("fzf-lua").nvim_options() end, desc = "neovim options" },
    { "<leader>sp", function() require("fzf-lua").spell_suggest() end, desc = "spelling suggestions" },
    { "<leader>fh", function() require("fzf-lua").highlights() end, desc = "Search highlight groups" },
    { "<leader>sC", function() require("fzf-lua").commands() end, desc = "Search commands" },
    { "<leader>fm", function() require("fzf-lua").marks() end, desc = "Search marks" },
    { "<leader>fk", function() require("fzf-lua").keymaps() end, desc = "Search keymaps" },
    { "<leader>fC", function() require("fzf-lua").colorschemes() end, desc = "Search colorschemes" },
    { "<leader>fA", function() require("fzf-lua").awesome_colorschemes() end, desc = "Awesome colorschemes" },
    -- stylua: ignore stop
  },
  enabled = true,
  opts = {
    "default-title",
    fzf_colors = false,
    fzf_opts = {
      ["--layout"] = false,
    },
    winopts = {
      border = require("config.ui.border").default_border,
      backdrop = 100,
      height = vim.g.float_height,
      width = vim.g.float_width,

      -- center on screen
      row = 0.55,
      col = 0.51,

      preview = {
        -- scrollchars = { "┃", "" },
        delay = 10,
        scrollbar = false,
        layout = "horizontal",
        horizontal = "right:50%",
        hidden = function()
          return vim.o.columns < 120
        end,
      },
    },
    keymap = {
      fzf = {
        ["change"] = "top",
        ["tab"] = "down",
        ["shift-tab"] = "up",
      },
    },
    files = {
      formatter = { "path.filename_first", 2 },
      git_icons = true,
    },
    diagnostics = {
      winopts = {
        preview = { hidden = "hidden" },
      },
    },
    lsp = {
      code_actions = {
        previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
      },
      symbols = {
        symbol_icons = require("config.ui.kinds").icons,
      },
    },
    git = {
      icons = {
        ["M"] = { icon = signs.fzf.git.modified, color = "yellow" },
        ["D"] = { icon = signs.fzf.git.removed, color = "red" },
        ["A"] = { icon = signs.fzf.git.added, color = "green" },
        ["R"] = { icon = signs.fzf.git.renamed, color = "yellow" },
      },
    },
  },
  config = function(_, opts)
    local fzf = require("fzf-lua")

    -- if opts[1] == "default-title" then
    --   -- use the same prompt for all pickers for profile `default-title` and
    --   -- profiles that use `default-title` as base profile
    --   local function fix(t)
    --     t.prompt = t.prompt ~= nil and " " or nil
    --     for _, v in pairs(t) do
    --       if type(v) == "table" then
    --         fix(v)
    --       end
    --     end
    --     return t
    --   end
    --   opts = vim.tbl_deep_extend("force", fix(require("fzf-lua.profiles.default-title")), opts)
    --   opts[1] = nil
    -- end
    fzf.setup(opts)
    fzf.register_ui_select()

    -- vim.api.nvim_create_autocmd("VimEnter", {
    --   callback = function()
    --     vim.wo.number = false
    --     vim.wo.relativenumber = false
    --     fzf.files()
    --   end,
    -- })
  end,
}
