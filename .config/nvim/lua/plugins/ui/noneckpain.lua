return {
  "shortcuts/no-neck-pain.nvim",
  event = "BufEnter",
  enabled = false, --not vim.env.TMUX_NEOGIT_POPUP,

  opts = {
    width = 140,
    -- Represents the lowest width value a side buffer should be.
    -- This option can be useful when switching window size frequently, example:
    -- in full screen screen, width is 210, you define an NNP `width` of 100, which creates each side buffer with a width of 50. If you resize your terminal to the half of the screen, each side buffer would be of width 5 and thereforce might not be useful and/or add "noise" to your workflow.
    ---@type integer
    minSideBufferWidth = 20,
    -- Disables the plugin if the last valid buffer in the list have been closed.
    ---@type boolean
    disableOnLastBuffer = false,
    autocmds = {
      -- When `true`, enables the plugin when you start Neovim.
      -- If the main window is  a side tree (e.g. NvimTree) or a dashboard, the command is delayed until it finds a valid window.
      -- The command is cleaned once it has successfuly ran once.
      -- When `safe`, debounces the plugin before enabling it.
      -- This is recommended if you:
      --  - use a dashboard plugin, or something that also triggers when Neovim is entered.
      --  - usually leverage commands such as `nvim +line file` which are executed after Neovim has been entered.
      ---@type boolean | "safe"
      enableOnVimEnter = true,
      -- When `true`, enables the plugin when you enter a new Tab.
      -- note: it does not trigger if you come back to an existing tab, to prevent unwanted interfer with user's decisions.
      ---@type boolean
      enableOnTabEnter = true,
      -- When `true`, reloads the plugin configuration after a colorscheme change.
      ---@type boolean
      reloadOnColorSchemeChange = false,
      -- When `true`, entering one of no-neck-pain side buffer will automatically skip it and go to the next available buffer.
      ---@type boolean
      skipEnteringNoNeckPainBuffer = true,
    },
  },
}
