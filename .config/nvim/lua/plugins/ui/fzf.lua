local signs = require("config.ui.signs")

return {
  "ibhagwan/fzf-lua",
  -- dependencies = {
  --   -- "elanmed/fzf-lua-frecency.nvim",
  -- },
  keys = {
    "<leader>ff",
    "<leader>fb",
    "<leader>fr",
    "<leader>fG",
    "<leader>fg",
    "<leader>fl",
    "<leader>fw",
    "<leader>ft",
    "<leader>fB",
    "<leader>fd",

    -- { "<Tab>", '<cmd>lua require("user_plugins.switchbuffer").select_buffers()<cr>' },
    -- { "<S-Tab>", '<cmd>lua require("user_plugins.switchbuffer").select_buffers()<cr>' },
  },
  enabled = true,
  opts = {
    "hide",
    fzf_colors = true,
    winopts = {
      border = require("config.ui.border").default_border,
      backdrop = 100,
      width = 0.8,
      height = 0.8,
      row = 0.5,
      col = 0.5,
      preview = {
        scrollchars = { "┃", "" },
        delay = 10,
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
      formatter = "path.filename_first",
      ignore_patterns = { "*.gif" },
      fd_opts = "--type f --hidden --follow",
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

    vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "find files" })
    vim.keymap.set("n", "<leader>fp", fzf.global, { desc = "find globals" })
    vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "find buffers" })
    vim.keymap.set("n", "<leader>fB", fzf.builtin, { desc = "show fzf builtins" })
    vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "find all lsp references" })
    vim.keymap.set("n", "<leader>fG", fzf.git_files, { desc = "find git files" })
    vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "grep words inside files" })
    vim.keymap.set("n", "<leader>fl", fzf.resume, { desc = "resume grep" })
    vim.keymap.set("n", "<leader>fw", fzf.grep_cword, { desc = "grep string under cursor" })
    vim.keymap.set("n", "<leader>ft", function()
      fzf.grep({ search = "TODO|HACK|PERF|NOTE|FIX|WARN", no_esc = true })
    end, { desc = "Search all todos" })

    vim.keymap.set("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "Toggle fzf diagnostic" })

    -- vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "show documentations" })
    -- vim.keymap.set("n", "<leader>fm", "<cmd>telescope harpoon marks<cr>", { desc = "open harpoon marks" })
    -- vim.keymap.set("n", "<leader>c", function()
    --     require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({}))
    --     end, { desc = "spelling suggestions" })
    -- vim.keymap.set("n", "*", fuzzy_find_under_cursor, { desc = "fuzzy find in file under cursor" })
    require("fzf-lua").register_ui_select()
  end,
}
