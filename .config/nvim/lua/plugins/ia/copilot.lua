local utils = require("utils")

return {
  {
    "zbirenbaum/copilot.lua",
    dependencies = {
      "saghen/blink.cmp",
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
        copilot_model = "gpt-4o-copilot",
        server = {
          type = "binary", -- "nodejs" | "binary"
          custom_server_filepath = nil,
        },
      })

      vim.keymap.set("i", "<tab>", function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
          return "<Ignore>"
        end
        return "<tab>"
      end, { expr = true, noremap = true })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = true,
    branch = "main",
    build = "make tiktoken",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>cc",
        mode = { "n", "v" },
        "<cmd>CopilotChat<CR>",
        desc = "CopilotChat - Help actions",
      },
      {
        "<leader>ch",
        mode = { "n", "v" },
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "CopilotChat - Help actions",
      },
      -- Show prompts actions with telescope
      {
        "<leader>cp",
        function()
          require("CopilotChat").select_prompt({
            selection = require("CopilotChat.select").visual,
          })
        end,
        mode = { "n", "x", "v" },
        desc = "CopilotChat - Prompt actions",
      },

      {
        "<leader>cq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Quick chat",
      },
    },
    opts = function()
      local user = vim.env.USER or "User"
      -- user = user:sub(1, 1):upper() .. user:sub(2)

      return {
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        error_header = "  Error ",
        separator = "───",
        model = "gpt-4o",
        show_folds = false,
        auto_follow_cursor = false,
        debug = false,
        log_level = "error",
        -- context = "buffer",

        selection = function(source)
          return require("CopilotChat.select").visual(source) or ""
        end,

        prompts = {
          Refactor = {
            prompt = "Refactor the following code to improve readability, maintainability, and professionalism while keeping the same functionality. Ensure the code remains simple, clean, and easy to understand. Use clear variable and function names, add meaningful comments where necessary, and follow best coding practices.",
          },
          BetterNamings = {
            prompt = "/COPILOT_GENERATE Provide better names for the following variables and/or functions.",
          },
          TestsxUnit = {
            prompt = "/COPILOT_GENERATE Write a set of detailed unit test functions for the following code with the xUnit framework.",
          },
        },
        mappings = {
          show_diff = {
            normal = "cd",
          },
          complete = {
            insert = "",
          },
        },
      }
    end,
    config = function(_, opts)
      local chat = require("CopilotChat")

      -- require("CopilotChat.integrations.cmp").setup()
      chat.setup(opts)

      vim.keymap.set("n", "<leader>cy", function()
        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

        local start_line = nil
        for i = #lines, 1, -1 do
          if lines[i]:find("Copilot") then
            start_line = i
            break
          end
        end

        if not start_line then
          print("Copilot header not found")
          return
        end

        local code_block = {}
        local in_code_block = false
        for i = start_line, #lines do
          local line = lines[i]
          if line:find("^```") then
            if in_code_block then
              break
            else
              in_code_block = true
            end
          elseif in_code_block then
            table.insert(code_block, line)
          end
        end

        local code_str = table.concat(code_block, "\n")

        if #code_str > 0 then
          vim.fn.setreg("*", code_str)
          vim.fn.setreg("+", code_str)
          print("Code copied to system clipboard.")
        else
          print("No code found.")
        end
      end, { noremap = true, silent = true })

      -- Custom buffer for CopilotChat
      -- vim.api.nvim_create_autocmd("BufEnter", {
      -- 	pattern = "copilot-*",
      -- 	callback = function()
      -- 		vim.opt_local.relativenumber = false
      -- 		vim.opt_local.number = false
      --
      -- 		local ft = vim.bo.filetype
      -- 		if ft == "copilot-chat" then
      -- 			vim.bo.filetype = "markdown"
      -- 		end
      -- 	end,
      -- })
      -- Custom buffer for CopilotChat

      utils.on_event("BufEnter", function()
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
        vim.opt_local.statuscolumn = " "
        -- 			vim.bo.filetype = "markdown"
        -- require("cmp").setup.buffer({ enabled = false })
      end, {
        target = "copilot-*",
        desc = "Disable relative number and cmp for CopilotChat",
      })
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
      behaviour = {
        auto_set_keymaps = true,
        auto_suggestions = false,
        support_paste_from_clipboard = true,
        enable_cursor_planning_mode = true,
        enable_claude_text_editor_tool_mode = true,
      },
      providers = {
        copilot = {
          model = "gpt-4o",
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
