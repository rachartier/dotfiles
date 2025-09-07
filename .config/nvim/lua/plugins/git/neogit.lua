return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  lazy = not vim.env.TMUX_NEOGIT_POPUP,
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit" },
  },
  opts = {
    graph_style = "unicode",
    process_spinner = true,
    highlight = {
      italic = true,
      bold = true,
      underline = true,
    },
    git_services = {
      ["github.com"] = "https://github.com/${owner}/${repository}/compare/${branch_name}?expand=1",
      ["bitbucket.org"] = "https://bitbucket.org/${owner}/${repository}/pull-requests/new?source=${branch_name}&t=1",
      ["gitlab.com"] = "https://gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
      ["michelin.gitlab.com"] = "https://michelin.gitlab.com/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
      ["azure.com"] = "https://dev.azure.com/${owner}/_git/${repository}/pullrequestcreate?sourceRef=${branch_name}&targetRef=${target}",
    },
    signs = {
      section = { "", "" },
      item = { "", "" },
      hunk = { "", "" },
    },
    integrations = {
      diffview = true,
    },
  },
  config = function(_, opts)
    require("neogit").setup(opts)

    if vim.env.TMUX_NEOGIT_POPUP == "1" then
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

            if filetype == "snacks_dashboard" or (is_buffer_no_name(bufnr) and filetype == "") then
              vim.cmd("qall!")
            end
          end, 50)
        end,
      })
    end
  end,
}
