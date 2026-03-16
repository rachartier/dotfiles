vim.pack.add({ "https://github.com/folke/sidekick.nvim" }, { confirm = false })

local loaded = false
local tiny_diags_disabled_by_nes = false

local function load()
  if loaded then
    return
  end
  loaded = true

  require("sidekick").setup({
    nes = { enabled = true },
    mux = { backend = "tmux", enabled = true },
    cli = {
      win = {
        keys = {
          stopinsert = { "<esc>", "stopinsert", mode = "t" },
          win_p = { "<M-Left>", "blur" },
        },
      },
    },
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "SidekickNesHide",
    callback = function()
      if tiny_diags_disabled_by_nes then
        tiny_diags_disabled_by_nes = false
        require("tiny-inline-diagnostic").enable()
      end
    end,
    desc = "enable diagnostics when sidekick nes hides",
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "SidekickNesShow",
    callback = function()
      tiny_diags_disabled_by_nes = true
      require("tiny-inline-diagnostic").disable()
    end,
    desc = "disable diagnostics when sidekick nes shows",
  })
end

vim.keymap.set({ "n", "v" }, "<leader>aa", function()
  load()
  require("sidekick.cli").toggle({ name = "copilot", focus = true })
end, { silent = true, desc = "toggle sidekick cli" })
