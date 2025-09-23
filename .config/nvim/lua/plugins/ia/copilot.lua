local model = "gpt-4.1"

return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {

      "saghen/blink.cmp",
      {
        "copilotlsp-nvim/copilot-lsp",
        init = function()
          vim.g.copilot_nes_debounce = 100
        end,
      },
    },
    event = "LazyFile",
    keys = {
      {
        "<leader>c",
        function()
          require("copilot.panel").toggle()
        end,
      },
      {
        "<leader>cn",
        function()
          require("copilot.panel").jump_next()
        end,
      },
      {
        "<leader>cp",
        function()
          require("copilot.panel").jump_prev()
        end,
      },
    },
    config = function()
      require("copilot").setup({
        nes = {
          enabled = false, -- requires copilot-lsp as a dependency
          auto_trigger = true,
          keymap = {
            accept_and_goto = "<leader>p",
            accept = false,
            dismiss = "<Esc>",
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = false,
          },
        },
        panel = { enabled = true },
        filetypes = {
          sh = function()
            local filename = vim.fs.basename(vim.api.nvim_buf_get_name(0))
            if
              string.match(filename, "^%.env.*")
              or string.match(filename, "^%.secret.*")
              or string.match(filename, "^%id_rsa.*")
            then
              return false
            end

            return true
          end,
          ["copilot-chat"] = true,
          ["*"] = true,
          ["."] = true,
          markdown = true,
        },
        server = {
          type = "binary", -- "nodejs" | "binary"
          custom_server_filepath = nil,
        },
      })

      -- vim.keymap.set("i", "<tab>", function()
      --   if require("copilot.suggestion").is_visible() then
      --     require("copilot.suggestion").accept()
      --     return "<Ignore>"
      --   end
      --   return "<tab>"
      -- end, { expr = true, noremap = true })
    end,
  },
  {
    -- dir = os.getenv("HOME") .. "/dev/nvim_plugins/avante.nvim",
    "yetone/avante.nvim",
    enabled = true,
    version = false,
    build = "make",
    keys = {
      "<leader>aa",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- "github/copilot.vim",
      "zbirenbaum/copilot.lua",
      "echasnovski/mini.icons",
      "folke/snacks.nvim",
      "ravitemer/mcphub.nvim",
      -- {
      -- 	"HakonHarnes/img-clip.nvim",
      -- 	event = "VeryLazy",
      -- 	opts = {
      -- 		default = {
      -- 			embed_image_as_base64 = false,
      -- 			prompt_for_file_name = false,
      -- 			drag_and_drop = {
      -- 				insert_mode = true,
      -- 			},
      -- 			use_absolute_path = true,
      -- 		},
      -- 	},
      -- },
    },
    opts = {
      input = {
        provider = "snacks",
      },
      disabled_tools = {
        "list_files", -- Built-in file operations
        "replace_in_file",
        "search_files",
        "read_file",
        "create_file",
        "rename_file",
        "delete_file",
        "create_dir",
        "rename_dir",
        "delete_dir",
        "bash", -- Built-in terminal access
      },
      behaviour = {
        auto_set_keymaps = true,
        auto_suggestions = false,
        support_paste_from_clipboard = true,
        enable_cursor_planning_mode = true,
        enable_claude_text_editor_tool_mode = true,
      },
      providers = {
        copilot = {
          model = model,
          extra_request_body = {
            max_tokens = 64000,
          },
        },
      },
      provider = "copilot",
      cursor_applying_provider = "copilot",
      web_search_engine = {
        provider = "google", -- tavily, serpapi, searchapi, google or kagi
      },
      hints = { enabled = true },
      windows = {
        postion = "right",
        width = 40,
        sidebar_header = {
          enabled = true,
          align = "left",
          rounded = false,
        },
        input = {
          prefix = " ",
          height = 12,
        },
      },
      system_prompt = function()
        local hub = require("mcphub").get_hub_instance()
        return hub:get_active_servers_prompt()
      end,

      custom_tools = function()
        return {
          require("mcphub.extensions.avante").mcp_tool(),
        }
      end,
    },
  },
}
