local M = {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPre", "BufNewFile" },
}

function M.config()
    local builtin = require("statuscol.builtin")

    local gitsigns_bar = "▌"

    local gitsigns_hl_pool = {
        GitSignsAdd = "DiagnosticOk",
        GitSignsChange = "DiagnosticWarn",
        GitSignsChangedelete = "DiagnosticWarn",
        GitSignsDelete = "DiagnosticError",
        GitSignsTopdelete = "DiagnosticError",
        GitSignsUntracked = "NonText",
    }

    local diag_signs_icons = {
        DiagnosticSignError = " ",
        DiagnosticSignWarn = " ",
        DiagnosticSignInfo = " ",
        DiagnosticSignHint = "",
        DiagnosticSignOk = " ",
    }

    local function get_sign_name(cur_sign)
        if cur_sign == nil then
            return nil
        end

        cur_sign = cur_sign[1]

        if cur_sign == nil then
            return nil
        end

        cur_sign = cur_sign.signs

        if cur_sign == nil then
            return nil
        end

        cur_sign = cur_sign[1]

        if cur_sign == nil then
            return nil
        end

        return cur_sign["name"]
    end

    local function mk_hl(group, sym)
        return table.concat({ "%#", group, "#", sym, "%*" })
    end

    local function get_name_from_group(bufnum, lnum, group)
        local cur_sign_tbl = vim.fn.sign_getplaced(bufnum, {
            group = group,
            lnum = lnum,
        })

        return get_sign_name(cur_sign_tbl)
    end

    _G.get_statuscol_gitsign = function(bufnr, lnum)
        local cur_sign_nm = get_name_from_group(bufnr, lnum, "gitsigns_vimfn_signs_")

        if cur_sign_nm ~= nil then
            return mk_hl(gitsigns_hl_pool[cur_sign_nm], gitsigns_bar)
        else
            return " "
        end
    end

    local cfg = {
        separator = " ", -- separator between line number and buffer text ("│" or extra " " padding)

        -- Builtin line number string options for ScLn() segment
        thousands = false, -- or line number thousands separator string ("." / ",")
        relculright = false, -- whether to right-align the cursor line number with 'relativenumber' set
        -- Custom line number string options for ScLn() segment
        lnumfunc = nil, -- custom function called by ScLn(), should return a string
        reeval = false, -- whether or not the string returned by lnumfunc should be reevaluated
        -- Builtin 'statuscolumn' options
        setopt = true, -- whether to set the 'statuscolumn', providing builtin click actions
        segments = {
            { text = { "%C" }, click = "v:lua.ScFa" },
            -- {
            --     text = { builtin.lnumfunc, "│" },
            --     condition = { true, builtin.not_empty },
            --     click = "v:lua.ScLa",
            -- },
            {
                sign = { name = { "Diagnostic" } },
                click = "v:lua.ScSa",
            },
            {
                sign = { name = { ".*" }, namespace = { "gitsigns" } },
                click = "v:lua.ScLa",
                maxwidth = 1,
                fillchar = "|",
            },
        },
        -- Click actions
        Lnum = builtin.lnum_click,
        FoldPlus = builtin.foldplus_click,
        FoldMinus = builtin.foldminus_click,
        FoldEmpty = builtin.foldempty_click,
        DapBreakpointRejected = builtin.toggle_breakpoint,
        DapBreakpoint = builtin.toggle_breakpoint,
        DapBreakpointCondition = builtin.toggle_breakpoint,
        DiagnosticSignError = builtin.diagnostic_click,
        DiagnosticSignHint = builtin.diagnostic_click,
        DiagnosticSignInfo = builtin.diagnostic_click,
        DiagnosticSignWarn = builtin.diagnostic_click,
        GitSignsTopdelete = builtin.gitsigns_click,
        GitSignsUntracked = builtin.gitsigns_click,
        GitSignsAdd = builtin.gitsigns_click,
        GitSignsChangedelete = builtin.gitsigns_click,
        GitSignsDelete = builtin.gitsigns_click,
    }

    require("statuscol").setup(cfg)
end

return M
