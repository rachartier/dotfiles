local tiny_diags_disabled_by_nes = false

return {
  {
    "folke/sidekick.nvim",
    enabled = true,
    lazy = true,
    opts = {
      nes = {
        enabled = true,
      },
    },
    config = function(_, opts)
      local sidekick = require("sidekick.nes")
      local inline_diag = require("tiny-inline-diagnostic")

      local old_handler = sidekick._handler
      local old_clear = sidekick.clear

      local new_handler = function(err, result, ctx, config)
        local res = result or { edits = {} }
        if not vim.tbl_isempty(res.edits) then
          tiny_diags_disabled_by_nes = true
          inline_diag.disable()
        end

        return old_handler(err, result, ctx, config)
      end

      local new_clear = function()
        if tiny_diags_disabled_by_nes then
          inline_diag.enable()
        end
        old_clear()
      end

      require("sidekick.nes")._handler = new_handler
      require("sidekick.nes").clear = new_clear

      require("sidekick").setup(opts)
    end,
  },
}
