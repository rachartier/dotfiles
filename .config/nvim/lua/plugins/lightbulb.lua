local M = {
    "kosayoda/nvim-lightbulb",
    enabled = false,
}

function M.config()
    require("nvim-lightbulb").setup({
        autocmd = {
            enabled = true,
        },

        -- Configuration for various handlers:
        -- 1. Sign column.
        sign = {
            enabled = true,
            -- Text to show in the sign column.
            -- Must be between 1-2 characters.
            text = "💡",
            -- Highlight group to highlight the sign column text.
            hl = "LightBulbSign",
        },

        -- 2. Virtual text.
        virtual_text = {
            enabled = false,
            -- Text to show in the virt_text.
            text = "💡",
            -- Position of virtual text given to |nvim_buf_set_extmark|.
            -- Can be a number representing a fixed column (see `virt_text_pos`).
            -- Can be a string representing a position (see `virt_text_win_col`).
            pos = "eol",
            -- Highlight group to highlight the virtual text.
            hl = "LightBulbVirtualText",
            -- How to combine other highlights with text highlight.
            -- See `hl_mode` of |nvim_buf_set_extmark|.
            hl_mode = "combine",
        },

        -- 3. Floating window.
        float = {
            enabled = false,
            -- Text to show in the floating window.
            text = "💡",
            -- Highlight group to highlight the floating window.
            hl = "LightBulbFloatWin",
            -- Window options.
            -- See |vim.lsp.util.open_floating_preview| and |nvim_open_win|.
            -- Note that some options may be overridden by |open_floating_preview|.
            win_opts = {
                focusable = false,
            },
        },

        -- 4. Status text.
        -- When enabled, will allow using |NvimLightbulb.get_status_text|
        -- to retrieve the configured text.
        status_text = {
            enabled = false,
            -- Text to set if a lightbulb is available.
            text = "💡",
            -- Text to set if a lightbulb is unavailable.
            text_unavailable = "",
        },
    })
end

return M
