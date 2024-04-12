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

local diagnostic_ns = vim.api.nvim_create_namespace("CursorDiagnostics")

local function get_current_pos_diags(diagnostics, curline, curcol)
    local current_pos_diags = {}

    for _, diag in ipairs(diagnostics) do
        if diag.lnum == curline and curcol >= diag.col and curcol <= diag.end_col then
            table.insert(current_pos_diags, diag)
        end
    end

    if next(current_pos_diags) == nil then
        if #diagnostics == 0 then
            return current_pos_diags
        end
        table.insert(current_pos_diags, diagnostics[1])
    end

    return current_pos_diags
end

local function get_virt_texts_from_diag(diag)
    local diag_type = { "Error", "Warn", "Info", "Hint" }

    local hi = diag_type[diag.severity]
    local virt_texts = { { "    ", "DiagnosticVirtualTextNone" } }

    local diag_hi = "DiagnosticVirtualText" .. hi
    local diag_inv_hi = "InvDiagnosticVirtualText" .. hi

    vim.list_extend(virt_texts, {
        { "", diag_inv_hi },
        { "●", diag_hi },
        { " " .. diag.message, diag_hi },
        { "", diag_inv_hi }
    })

    return virt_texts
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.api.nvim_create_autocmd({ "InsertEnter" }, {
            buffer = args.buf,
            callback = function()
                pcall(vim.api.nvim_buf_clear_namespace, args.buf, diagnostic_ns, 0, -1)
            end,
        })
        vim.api.nvim_create_autocmd({ "CursorHold" }, {
            buffer = args.buf,
            callback = function()
                pcall(vim.api.nvim_buf_clear_namespace, args.buf, diagnostic_ns, 0, -1)

                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                local curline = cursor_pos[1] - 1
                local curcol = cursor_pos[2]

                local diagnostics = vim.diagnostic.get(args.buf, { lnum = curline })

                if #diagnostics == 0 then
                    return
                end

                local current_pos_diags = get_current_pos_diags(diagnostics, curline, curcol)
                local virt_texts = get_virt_texts_from_diag(current_pos_diags[1])

                vim.api.nvim_buf_set_extmark(args.buf, diagnostic_ns, curline, 0, {
                    virt_text = virt_texts,
                    virt_lines_above = true,
                })
            end,
        })
    end,
})
