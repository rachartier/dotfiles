local M = {}

local function get_visual_selection()
  local _, ls, cs = unpack(vim.fn.getpos("v"))
  local _, le, ce = unpack(vim.fn.getpos("."))
  local lines = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
  return table.concat(lines, "\n")
end

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

function M.setup()
  local pick = require("mini.pick")
  local extra = require("mini.extra")

  extra.setup()

  -- Centered on screen (from :h MiniPick-examples)
  local win_config = function()
    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.618 * vim.o.columns)
    return {
      anchor = "NW",
      height = height,
      width = width,
      border = require("config.ui.border").default_border,
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
    }
  end

  pick.setup({
    delay = {
      async = 10,
      busy = 50,
    },
    options = {
      content_from_bottom = true,
      use_cache = true,
    },

    window = {
      config = win_config,
      prompt_caret = "▌ ",
      prompt_prefix = " ",
    },
  })

  vim.ui.select = MiniPick.ui_select

  -- Auto-choose when LSP picker has exactly one result
  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniPickMatch",
    callback = function()
      local opts = MiniPick.get_picker_opts()
      if not opts or not opts.source or not opts.source.name then
        return
      end
      if not opts.source.name:find("^LSP") then
        return
      end

      local items = MiniPick.get_picker_items()
      if not items or #items ~= 1 then
        return
      end

      vim.schedule(function()
        if not MiniPick.is_picker_active() then
          return
        end
        vim.api.nvim_input("<CR>")
      end)
    end,
  })

  -- Files & Buffers
  map("n", "<leader>ff", MiniPick.builtin.files, "find files")
  map("n", "<leader><leader>", MiniPick.builtin.files, "find files")
  map("n", "<leader>fb", MiniPick.builtin.buffers, "find buffers")
  map("n", "<leader>fc", function()
    MiniPick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } })
  end, "find config files")
  map("n", "<leader>fG", MiniExtra.pickers.git_files, "find git files")
  map("n", "<leader>fo", MiniExtra.pickers.oldfiles, "recent files")
  map("n", "<leader>fl", MiniPick.builtin.resume, "resume last picker")

  -- Grep & Search
  map("n", "<leader>fg", MiniPick.builtin.grep_live, "grep words inside files")
  map("n", "<leader>fw", function()
    MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
  end, "grep string under cursor")
  map("x", "<leader>fw", function()
    MiniPick.builtin.grep({ pattern = get_visual_selection() })
  end, "grep visual selection")
  map("n", "<leader>ft", function()
    MiniPick.builtin.grep({ pattern = "TODO|HACK|PERF|NOTE|FIX|WARN" })
  end, "search all todos")
  map("n", "<leader>sb", function()
    MiniExtra.pickers.buf_lines({ scope = "all" })
  end, "buffer lines")
  map("n", "<leader>sB", function()
    MiniExtra.pickers.buf_lines({ scope = "current" })
  end, "current buffer lines")
  map("n", "<leader>sg", function()
    MiniExtra.pickers.buf_lines({ scope = "current" })
  end, "live grep current buffer")

  -- LSP
  map("n", "<leader>fr", function()
    MiniExtra.pickers.lsp({ scope = "references" })
  end, "find all lsp references")
  map("n", "<leader>fs", function()
    MiniExtra.pickers.lsp({ scope = "document_symbol" })
  end, "search document symbols")
  map("n", "<leader>fS", function()
    MiniExtra.pickers.lsp({ scope = "workspace_symbol" })
  end, "search workspace symbols")
  map("n", "<leader>fL", function()
    MiniExtra.pickers.lsp({ scope = "workspace_symbol_live" })
  end, "live workspace symbols")
  map("n", "<leader>st", MiniExtra.pickers.treesitter, "treesitter symbols")
  map("n", "gd", function()
    MiniExtra.pickers.lsp({ scope = "definition" })
  end, "goto definition")
  map("n", "gD", function()
    MiniExtra.pickers.lsp({ scope = "declaration" })
  end, "goto declaration")
  map("n", "gI", function()
    MiniExtra.pickers.lsp({ scope = "implementation" })
  end, "goto implementation")
  map("n", "gy", function()
    MiniExtra.pickers.lsp({ scope = "type_definition" })
  end, "goto type definition")
  map("n", "gai", vim.lsp.buf.incoming_calls, "incoming calls")
  map("n", "gao", vim.lsp.buf.outgoing_calls, "outgoing calls")

  -- Diagnostics
  map("n", "<leader>fd", function()
    MiniExtra.pickers.diagnostic({ scope = "all" })
  end, "workspace diagnostics")
  map("n", "<leader>sD", function()
    MiniExtra.pickers.diagnostic({ scope = "current" })
  end, "buffer diagnostics")

  -- Git
  map("n", "<leader>gb", MiniExtra.pickers.git_branches, "git branches")
  map("n", "<leader>gl", MiniExtra.pickers.git_commits, "git log")
  map("n", "<leader>gf", function()
    MiniExtra.pickers.git_commits({ path = vim.fn.expand("%") })
  end, "git log file")
  map("n", "<leader>gd", MiniExtra.pickers.git_hunks, "git diff/hunks")

  -- Neovim Utilities
  map("n", "<leader>:", function()
    MiniExtra.pickers.history({ scope = ":" })
  end, "command history")
  map("n", '<leader>s"', MiniExtra.pickers.registers, "registers")
  map("n", "<leader>s/", function()
    MiniExtra.pickers.history({ scope = "/" })
  end, "search history")
  map("n", "<leader>sh", MiniPick.builtin.help, "help pages")
  map("n", "<leader>sj", function()
    MiniExtra.pickers.list({ scope = "jump" })
  end, "jumps")
  map("n", "<leader>sc", function()
    MiniExtra.pickers.list({ scope = "change" })
  end, "changes")
  map("n", "<leader>sl", function()
    MiniExtra.pickers.list({ scope = "location" })
  end, "location list")
  map("n", "<leader>sq", function()
    MiniExtra.pickers.list({ scope = "quickfix" })
  end, "quickfix list")
  map("n", "<leader>so", MiniExtra.pickers.options, "neovim options")
  map("n", "<leader>sp", MiniExtra.pickers.spellsuggest, "spelling suggestions")
  map("n", "<leader>fh", MiniExtra.pickers.hl_groups, "search highlight groups")
  map("n", "<leader>sC", MiniExtra.pickers.commands, "search commands")
  map("n", "<leader>fm", MiniExtra.pickers.marks, "search marks")
  map("n", "<leader>fk", MiniExtra.pickers.keymaps, "search keymaps")
  map("n", "<leader>fC", MiniExtra.pickers.colorschemes, "search colorschemes")
end

return M
