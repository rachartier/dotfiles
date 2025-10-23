local signs = require("config.ui.signs")

return {
  "ibhagwan/fzf-lua",
  dependencies = {
    -- "elanmed/fzf-lua-frecency.nvim",
  },
  keys = {
    -- stylua: ignore start
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
    { "<leader>fr", function() require("fzf-lua").lsp_references() end, desc = "find all lsp references" },
    { "<leader>fG", function() require("fzf-lua").git_files() end, desc = "find git files" },
    { "<leader>fg", function() require("fzf-lua").live_grep() end, desc = "grep words inside files" },
    { "<leader>fl", function() require("fzf-lua").resume() end, desc = "resume grep" },
    { "<leader>fw", function() require("fzf-lua").grep_cword() end, desc = "grep string under cursor" },
    { "<leader>ft", function() require("fzf-lua").grep({ search = "TODO|HACK|PERF|NOTE|FIX|WARN", no_esc = true }) end, desc = "Search all todos" },
    { "<leader>fd", function() require("fzf-lua").diagnostics_workspace() end, desc = "Toggle fzf diagnostic" },
    { "<leader>fh", function() require("fzf-lua").highlights() end, desc = "Search highlight groups" },
    { "<leader>fc", function() require("fzf-lua").commands() end, desc = "Search commands" },
    { "<leader>fm", function() require("fzf-lua").marks() end, desc = "Search marks" },
    { "<leader>fk", function() require("fzf-lua").keymaps() end, desc = "Search keymaps" },
    { "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, desc = "Search document symbols" },
    { "<leader>fS", function() require("fzf-lua").lsp_workspace_symbols() end, desc = "Search workspace symbols" },
    { "<leader>fC", function() require("fzf-lua").colorschemes() end, desc = "Search colorschemes" },
    -- stylua: ignore stop
  },
  enabled = false,
  opts = {
    { "border-fused", "hide" },
    fzf_colors = true,
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
        layout = "vertical",
        vertical = "up:60%",

        -- hidden = function()
        --   return false
        -- end, -- layout = "vertical",
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
  end,
}
