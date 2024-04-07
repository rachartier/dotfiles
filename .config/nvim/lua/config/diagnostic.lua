local U = require("utils")

vim.fn.sign_define("DiagnosticSignError", { text = U.signs.diagnostic.error, texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = U.signs.diagnostic.warning, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = U.signs.diagnostic.info, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = U.signs.diagnostic.hint, texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
    float = { border = require("config.icons").default_border },
    underline = true,
    update_in_insert = false,
    -- virtual_lines = {
    --     highlight_whole_line = false,
    --     -- only_current_line = true,
    -- },
    -- virtual_improved = {
    --     current_line = "only",
    -- },
    virtual_text = false, -- virtual_text = {
    -- 	prefix = function(diagnostic)
    -- 		if diagnostic.severity == vim.diagnostic.severity.ERROR then
    -- 			return U.signs.diagnostic.error
    -- 		elseif diagnostic.severity == vim.diagnostic.severity.WARN then
    -- 			return U.signs.diagnostic.warning
    -- 		elseif diagnostic.severity == vim.diagnostic.severity.INFO then
    -- 			return U.signs.diagnostic.info
    -- 		else
    -- 			return U.signs.diagnostic.hint
    -- 		end
    -- 	end,
    -- },
    signs = {
        ["WARN"] = U.signs.diagnostic.warning,
        ["ERROR"] = U.signs.diagnostic.error,
        ["INFO"] = U.signs.diagnostic.info,
        ["HINT"] = U.signs.diagnostic.hint,
    },
    severity_sort = true,
})

local ns = vim.api.nvim_create_namespace("CurlineDiag")
vim.opt.updatetime = 100
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = args.buf,
            callback = function()
                pcall(vim.api.nvim_buf_clear_namespace, args.buf, ns, 0, -1)
                local diag_type = { "Error", "Warn", "Info", "Hint" }

                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                local curline = cursor_pos[1] - 1 -- Subtract 1 to convert to 0-based indexing
                local curcol = cursor_pos[2]

                local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline })


                if #diagnostics == 0 then
                    return
                end

                local current_pos_diags = {}
                local index_diag = 1

                for i, diag in ipairs(diagnostics) do
                    if diag.lnum == curline and curcol >= diag.col and curcol <= diag.end_col then
                        index_diag = i
                        table.insert(current_pos_diags, diag)
                    end
                end

                if next(current_pos_diags) == nil then
                    table.insert(current_pos_diags, diagnostics[1])
                end

                -- local virt_texts = { { (" "):rep(4) } }
                local virt_texts = { { "     ", "LineNr" } }
                local separator = " "

                local diag = current_pos_diags[1]
                local hi = diag_type[diag.severity]
                -- local hl_bg_diag = vim.api.nvim_get_hl_by_name(hi, true).background

                -- if i == #diagnostics then
                --     separator = ""
                -- end

                table.insert(virt_texts,
                    { "", "InvDiagnosticVirtualText" .. hi })

                for _, other_diag in ipairs(diagnostics) do
                    hi = diag_type[other_diag.severity]
                    table.insert(virt_texts,
                        { "●", "DiagnosticVirtualText" .. hi }
                    )
                end

                table.insert(virt_texts,
                    { " " .. diag.message, "DiagnosticVirtualText" .. hi }
                )

                table.insert(virt_texts,

                    { "", "InvDiagnosticVirtualText" .. hi }
                )

                -- if i < #diagnostics then
                --     virt_texts[#virt_texts + 1] = { separator }
                -- end


                -- for i, diag in ipairs(diagnostics) do
                -- end
                if #diagnostics >= 1 then
                    vim.api.nvim_buf_set_extmark(args.buf, ns, curline, 0, {
                        virt_text = virt_texts,
                        virt_lines_above = true,
                        -- line_hl_group = "DiagnosticVirtualTextError",
                    })
                end
            end,
        })
    end,
})
