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
                function()
                    local actions = require("CopilotChat.actions")
                    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
                end,
                mode = { "n", "x", "v" },
                desc = "CopilotChat - Prompt actions",
            },
            -- {
            --     "<leader>cp",
            --     function()
            --         require("utils").copy_visual_selection()
            --         local actions = require("CopilotChat.actions")
            --         require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
            --     end,
            --     mode = { "x", "v" },
            --     desc = "CopilotChat - Prompt actions",
            -- },
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
                --                 Docs = [[
                -- Generate the documentation for the code above.
                -- The documentation should be in the form of the standard from the language.
                -- The documentation should be in the form of comments.
                -- It should only focus on what the code does, not what the code is for.
                -- It should be clear and concise and precise.
                -- The documentation must be helpful to someone who has never seen the code before.
                -- The documentation must be in English.
                -- It should start by a brief description of the code, then the inputs, then the outputs, and then the exceptions.
                -- Output with no introduction, no explaintation, only the generated documentation.
                -- DONT MAKE ANY MISTAKES, check if you did any.
                -- ]],
                Docs = [[
Please provide documentation for the following code, and follow these instructions to help you:
- It should only focus on what the code does, not what the code is for.
- It should be clear and concise and precise.
- The documentation must be helpful to someone who has never seen the code before.
- It should start by a brief description of what the code does, then the inputs, then the outputs, and then the exceptions.
- Output with no introduction, no explaintation, only the documentation.
- DONT MAKE ANY MISTAKES, check if you did any.
]],
                TestsxUnit = {
                    prompt =
                    "/COPILOT_TESTS Write a set of detailed unit test functions for the following code with the xUnit framework.",
                },
            },
        },
        config = function(_, opts)
            local chat = require("CopilotChat")
            local select = require("CopilotChat.select")

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

            vim.keymap.set('n', '<leader>cy', function()
                local buf = vim.api.nvim_get_current_buf()
                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                local code = {}
                local is_after_copilot = false
                local found_code_start = false

                for _, line in ipairs(lines) do
                    if not is_after_copilot and string.find(line, "Copilot") then
                        is_after_copilot = true
                    elseif is_after_copilot and not found_code_start then
                        if string.find(line, "^```") then
                            found_code_start = true
                        end
                    elseif is_after_copilot and found_code_start then
                        if string.find(line, "^```") then
                            break
                        else
                            table.insert(code, line)
                        end
                    end
                end

                local code_str = table.concat(code, "\n")

                if #code_str > 0 then
                    vim.fn.setreg("*", code_str)
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
        end,
    },
}
