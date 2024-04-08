return {
    {
        "echasnovski/mini.splitjoin",
        version = false,
        config = function()
            require("mini.splitjoin").setup({
                -- Module mappings. Use `''` (empty string) to disable one.
                -- Created for both Normal and Visual modes.
                mappings = {
                    toggle = "gS",
                    split = "",
                    join = "",
                },
            })
        end,
        event = { "InsertEnter" },
    },
    {
        "echasnovski/mini.surround",
        config = function()
            require("mini.surround").setup({})
        end,
    },
    {
        "echasnovski/mini.hipatterns",
        config = function()
            local hipatterns = require("mini.hipatterns")

            hipatterns.setup({
                highlighters = {
                    -- Highlight hex color strings (`#rrggbb`) using that color
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    }
}
