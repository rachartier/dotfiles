--require('mini.surround').setup {
--    -- Add custom surroundings to be used on top of builtin ones. For more
--    -- information with examples, see `:h MiniSurround.config`.
--    custom_surroundings = nil,
--
--    -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
--    highlight_duration = 500,
--
--    -- Module mappings. Use `''` (empty string) to disable one.
--    mappings = {
--        add = 'sa', -- Add surrounding in Normal and Visual modes
--        delete = 'sd', -- Delete surrounding
--        find = 'sf', -- Find surrounding (to the right)
--        find_left = 'sF', -- Find surrounding (to the left)
--        highlight = 'sh', -- Highlight surrounding
--        replace = 'sr', -- Replace surrounding
--        update_n_lines = 'sn', -- Update `n_lines`
--
--        suffix_last = 'l', -- Suffix to search with "prev" method
--        suffix_next = 'n', -- Suffix to search with "next" method
--    },
--
--    -- Number of lines within which surrounding is searched
--    n_lines = 20,
--
--    -- How to search for surrounding (first inside current line, then inside
--    -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
--    -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
--    -- see `:h MiniSurround.config`.
--    search_method = 'cover',
--}

require('mini.splitjoin').setup {
    -- Module mappings. Use `''` (empty string) to disable one.
    -- Created for both Normal and Visual modes.
    mappings = {
        toggle = 'gS',
        split = '',
        join = '',
    },

    -- Detection options: where split/join should be done
    detect = {
        -- Array of Lua patterns to detect region with arguments.
        -- Default: { '%b()', '%b[]', '%b{}' }
        brackets = nil,

        -- String Lua pattern defining argument separator
        separator = ',',

        -- Array of Lua patterns for sub-regions to exclude separators from.
        -- Enables correct detection in presence of nested brackets and quotes.
        -- Default: { '%b()', '%b[]', '%b{}', '%b""', "%b''" }
        exclude_regions = nil,
    },

    -- Split options
    split = {
        hooks_pre = {},
        hooks_post = {},
    },

    -- Join options
    join = {
        hooks_pre = {},
        hooks_post = {},
    },
}
