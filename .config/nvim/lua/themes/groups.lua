local M = {}

function M.get(colors)
  local default_bg = "None"

  return {
    FloatBorder = { fg = colors.overlay2, bg = default_bg },
    FloatTitle = { bg = colors.base, fg = colors.text, italic = true, bold = true },
    Comment = { fg = colors.surface2, italic = true },

    BlinkCmpSignatureHelpBorder = { bg = colors.surface0 },
    BlinkCmpSignatureHelp = { bg = colors.surface0, fg = colors.subtext0 },
    BlinkCmpSignatureHelpActiveParameter = { bg = colors.surface1, fg = colors.text },
    BlinkCmpDocBorder = { bg = colors.surface0 },
    BlinkCmpDocSeparator = { bg = colors.surface0 },
    BlinkCmpMenu = { bg = colors.surface0 },
    BlinkCmpDoc = { bg = colors.surface0 },
    BlinkCmpScrollBarGutter = { bg = colors.surface2 },
    BlinkCmpScrollBarThumb = { bg = colors.subtext0 },
    BlinkCmpMenuSelection = { bg = colors.surface1 },
    BlinkCmpLabelDetail = { bg = colors.maroon, fg = colors.base },
    BlinkCmpLabelDescription = { link = "BlinkCmpLabelDetail" },
    BlinkCmpLabelMatch = { fg = colors.blue },

    CursorLine = { bg = "None" },
    CursorLineNr = { fg = colors.subtext0 },
    CursorLineSign = { link = "SignColumn" },
    CursorColumn = { bg = default_bg },

    FlashLabel = { fg = colors.base, bg = colors.yellow, bold = true },

    GitSignsAdd = { fg = colors.green },
    GitSignsChange = { fg = colors.blue },

    NeogitChangeModified = { italic = true },
    NeogitChangeAdded = { italic = true },
    NeogitChangeDeleted = { italic = true },
    NeogitChangeRenamed = { italic = true },
    NeogitChangeUpdated = { italic = true },
    NeogitChangeCopied = { italic = true },
    NeogitChangeUnmerged = { italic = true },
    NeogitChangeNewFile = { italic = true },
    NeogitSectionHeader = { italic = true },

    NoicePopupmenu = { bg = colors.mantle },
    NoicePopup = { bg = colors.surface0, fg = colors.text },

    PopupBorder = { link = "FloatBorder" },

    SwitchBufferStatusColor = { fg = colors.red },

    SnacksDashboardHeader = { fg = colors.mauve },
    SnacksDashboardIcon = { fg = colors.mauve },
    SnacksDashboardDesc = { fg = colors.text },
    SnacksDashboardKey = { fg = colors.peach },
    SnacksDashboardFooter = { fg = colors.maroon },
    SnacksIndentScope = { fg = colors.surface1 },
    MiniIndentscopeSymbol = { fg = colors.surface1 },
    MiniStarterItemPrefix = { fg = colors.peach },
    MiniStarterFooter = { fg = colors.maroon },

    StatusLine = { fg = colors.text, bg = "None" },
    StatusLineNC = { link = "StatusLine" },

    DiagnosticUnnecessary = { fg = colors.overlay0 },

    WinSeparator = { fg = colors.surface1 },
    WinBar = { fg = colors.surface1, bg = default_bg },
    AvanteSidebarWinSeparator = { fg = colors.surface0, bg = default_bg },

    DapUIPlayPauseNC = { link = "DapUIPlayPause" },
    DapUIRestartNC = { link = "DapUIRestart" },
    DapUIStopNC = { link = "DapUIStop" },
    DapUIUnavailableNC = { link = "DapUIUnavailable" },
    DapUIStepOverNC = { link = "DapUIStepOver" },
    DapUIStepIntoNC = { link = "DapUIStepInto" },
    DapUIStepBackNC = { link = "DapUIStepBack" },
    DapUIStepOutNC = { link = "DapUIStepOut" },

    EdgyNormal = { bg = default_bg },
    EdgyWinBar = { bg = colors.surface0, fg = "None" },
    EdgyTitle = { bg = colors.surface0, fg = colors.blue },
    EdgyIconActive = { bg = colors.surface0, fg = colors.peach },

    HighlightUndo = { bg = colors.red, fg = colors.base },
    HighlightRedo = { bg = colors.green, fg = colors.base },

    MarkdownCheckboxYes = { fg = colors.green },
    MarkdownCheckboxNo = { fg = colors.red },
    MarkdownCheckboxFire = { fg = colors.red },
    MarkdownCheckboxIdea = { fg = colors.yellow },
    MarkdownCheckboxStar = { fg = colors.yellow },
    MarkdownCheckboxSkipped = { fg = colors.red },
    MarkdownCheckboxQuestion = { fg = colors.yellow },
    MarkdownCheckboxInfo = { fg = colors.sapphire },
    MarkdownCheckboxImportant = { fg = colors.peach },

    MarkviewCode = { bg = colors.orange },

    LualineCustomScrollBar = { fg = colors.base },

    CopilotSuggestion = { fg = colors.overlay1, italic = false },

    LspHoverNormal = { bg = colors.surface0 },
    LspHoverBorder = { bg = colors.surface0, fg = colors.overlay2 },
  }
end

function M.override_hl(colors_table)
  local colors = M.get(colors_table)

  for hl, col in pairs(colors) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

return M
