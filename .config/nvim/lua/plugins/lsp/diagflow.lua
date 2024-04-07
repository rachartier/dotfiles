local M = {

    "dgagn/diagflow.nvim",
    enabled = false,
}

function M.config()
    require("diagflow").setup({
        enable = true,
        scope = "cursor",                                      -- 'cursor', 'line' this changes the scope, so instead of showing errors under the cursor, it shows errors on the entire line.
        text_align = "right",                                  -- 'left', 'right'
        placement = "top",                                     -- 'top', 'inline'
        update_event = { "DiagnosticChanged", "BufReadPost" }, -- the event that updates the diagnostics cache
        show_sign = false,                                     -- set to true if you want to render the diagnostic sign before the diagnostic message
        render_event = { "DiagnosticChanged", "CursorMoved" },
    })
end

return M
