local username = vim.fn.expand("$USER")
return {
    {
        "github/copilot.vim",
        config = function()
            vim.keymap.set('i', '<C-g>', 'copilot#Accept("\\<CR>")', {
                expr = true,
                replace_keycodes = false
            })
            vim.g.copilot_no_tab_map = true
        end
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            "github/copilot.vim",
            -- {
            --     "zbirenbaum/copilot.lua",
            --
            --     config = function()
            --         vim.g.copilot_proxy_strict_ssl = false
            --
            --         require("copilot").setup({
            --             panel = {
            --                 enabled = true,
            --                 auto_refresh = true,
            --             },
            --             suggestion = {
            --                 enabled = true,
            --                 -- use the built-in keymapping for "accept" (<M-l>)
            --                 auto_trigger = true,
            --                 keymap = {
            --                     accept = "<C-g>",
            --                     accept_word = false,
            --                     accept_line = false,
            --                     next = "<M-]>",
            --                     prev = "<M-[>",
            --                     dismiss = "<C-]>",
            --                 },
            --             },
            --         })
            --
            --         -- local cmp_status_ok, cmp = pcall(require, "cmp")
            --         -- if cmp_status_ok then
            --         -- 	cmp.event:on("menu_opened", function()
            --         -- 		vim.b.copilot_suggestion_hidden = true
            --         -- 	end)
            --         --
            --         -- 	cmp.event:on("menu_closed", function()
            --         -- 		vim.b.copilot_suggestion_hidden = false
            --         -- 	end)
            --         -- end
            --     end,
            -- },
            "nvim-lua/plenary.nvim", -- for curl, log wrapper
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
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.telescope").pick(actions.help_actions())
                end,
                desc = "CopilotChat - Help actions",
            },
            -- Show prompts actions with telescope
            {
                "<leader>cp",
                mode = { "n", "v" },
                function()
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
                end,
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
        opts = {
            question_header = string.rep("-", #username + 3) .. "\n󰙃  " .. username,
            answer_header = "  **Copilot**",
            error_header = " **Error**",
            separator = " ",
            show_folds = false,

            prompts = {
                BetterNamings = "Please provide better names for the following variables and functions.",
                Docs = [[
Generate a succinct documentation of the specified function or method according to the standards of the language, without providing a detailed description of its functionality.
The documentation text should encapsulate the essence of what the function/method accomplishes, providing developers with a high-level understanding of its intended use.
Ensure that the documentation includes the parameters (if any), the return type (if applicable), and any exceptions thrown.
Avoid diving into implementation details and focus solely on conveying the overarching goal or outcome of the function/method.
]],
                TestsxUnit = {
                    prompt =
                    "/COPILOT_TESTS Write a set of detailed unit test functions for the code above with the xUnit framework.",
                },
            },
        },
        config = function(_, opts)
            local chat = require("CopilotChat")
            local select = require("CopilotChat.select")

            -- opts.selection = select.unnamed

            opts.prompts.Commit = {
                prompt = "Write commit message for the change with commitizen convention",
                selection = select.gitdiff,
            }
            opts.prompts.CommitStaged = {
                prompt = "Write commit message for the change with commitizen convention",
                selection = function(source)
                    return select.gitdiff(source, true)
                end,
            }

            chat.setup(opts)

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
        end,
    },
}
