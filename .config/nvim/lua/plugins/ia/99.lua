return {
  "ThePrimeagen/99",
  enabled = false,
  config = function()
    local _99 = require("99")
    vim.keymap.set("n", "<leader>cf", function()
      _99.fill_in_function()
    end)
    -- take extra note that i have visual selection only in v mode
    -- technically whatever your last visual selection is, will be used
    -- so i have this set to visual mode so i dont screw up and use an
    -- old visual selection
    --
    -- likely ill add a mode check and assert on required visual mode
    -- so just prepare for it now
    vim.keymap.set("v", "<leader>cv", function()
      _99.visual()
    end)
  end,
}
