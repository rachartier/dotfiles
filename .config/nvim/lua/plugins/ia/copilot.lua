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
                    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions({
                        selection = require("CopilotChat.select").visual,
                    }))
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

            selection = function(source)
                local select = require("CopilotChat.select")
                return select.visual(source) or select.line(source)
            end,

            prompts = {
                BetterNamings = {
                    prompt = "/COPILOT_GENERATE Please provide better names for the following variables and functions."
                },
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
                --                 Docs = {
                --                     prompt = [[/COPILOT_REFACTOR
                -- Please provide documentation for the following code, and follow these instructions to help you:
                -- - It should only focus on what the code does, not what the code is for.
                -- - It should be clear and concise and precise.
                -- - The documentation must be helpful to someone who has never seen the code before.
                -- - It should start by a brief description of what the code does, then the inputs, then the outputs, and then the exceptions.
                -- - Output with no introduction, no explaintation, only the documentation.
                -- - If the code in in csharp, output the markdown bloc with "```cs" instead of "```csharp".
                -- - DONT MAKE ANY MISTAKES, check if you did any.
                -- ]]
                --                 },
                TestsxUnit = {
                    prompt =
                    "/COPILOT_GENERATE Write a set of detailed unit test functions for the following code with the xUnit framework.",
                },
            },
        },
        config = function(_, opts)
            local chat = require("CopilotChat")

            chat.setup(opts)

            vim.keymap.set('n', '<leader>cy', function()
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
        end,
    },
}
