local loaded = false

local function load()
  if loaded then return end
  loaded = true

  vim.pack.add({
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/sindrets/diffview.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/NeogitOrg/neogit",
  }, { confirm = false })

  require("neogit").setup({
    graph_style = "unicode",
    process_spinner = true,
    highlight = { italic = true, bold = true, underline = true },
    git_services = {
      ["michelin.gitlab.com"] = {
        pull_request = "https://michelin.gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
        commit       = "https://michelin.gitlab.com/${owner}/${repository}/-/commit/${oid}",
        tree         = "https://michelin.gitlab.com/${owner}/${repository}/-/tree/${branch_name}?ref_type=heads",
      },
    },
    signs = {
      section = { "", "" },
      item    = { "", "" },
      hunk    = { "", "" },
    },
  })

  if vim.env.TMUX_NEOGIT_POPUP == "1" then
    pcall(function()
      require("vim._core.ui2").enable({ enable = false })
    end)

    local function is_buffer_no_name(bufnr)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      local name = vim.api.nvim_buf_get_name(bufnr)
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
      return name == "" and (buftype == "" or buftype == "acwrite")
    end

    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        vim.defer_fn(function()
          local bufnr = vim.api.nvim_get_current_buf()
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
          if is_buffer_no_name(bufnr) and filetype == "" then
            vim.cmd("qall!")
          end
        end, 50)
      end,
      desc = "quit neogit popup when empty buffer",
    })
  end
end

if vim.env.TMUX_NEOGIT_POPUP then
  load()
end

vim.api.nvim_create_user_command("Neogit", function(info)
  load()
  vim.api.nvim_del_user_command("Neogit")
  vim.cmd("Neogit " .. (info.args or ""))
end, { nargs = "?" })

vim.keymap.set("n", "<leader>gg", function()
  load()
  vim.cmd("Neogit")
end, { silent = true, desc = "open neogit" })
