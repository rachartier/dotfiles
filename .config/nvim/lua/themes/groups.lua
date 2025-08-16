local M = {}
local utils = require("utils")

local darken_markdown_heading = 0.16

function M.get(colors)
  local default_bg = "None"

  return {
    -- Visual = { bg = "#234370" },
    -- Visual = { bg = colors.blue, fg = colors.base },
    CurSearch = { bg = default_bg },

    -- NormalFloat = { bg = bg, fg = colors.text },
    -- NormalFloat = { bg = default_bg, fg = colors.text },
    FloatBorder = { fg = colors.overlay2, bg = default_bg },
    FloatTitle = { bg = colors.base, fg = colors.text, italic = true, bold = true },
    -- LineNr = { fg = colors.surface1 },
    -- SignColumn = { fg = colors.surface1 },
    -- Visual = { bg = colors.surface1 },
    Comment = { fg = colors.surface2, italic = true },

    BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
    BlinkCmpDocBorder = { bg = colors.surface0 },
    BlinkCmpDocSeparator = { bg = colors.surface0 },
    -- BlinkCmpMenuBorder = { link = "FloatBorder" },
    BlinkCmpMenu = { bg = colors.surface0 },

    BlinkCmpDoc = { bg = colors.surface0 },
    BlinkCmpScrollBarGutter = { bg = colors.surface2 },
    BlinkCmpScrollBarThumb = { bg = colors.subtext0 },
    BlinkCmpMenuSelection = { bg = colors.surface1 },
    BlinkCmpLabelDetail = { bg = colors.maroon, fg = colors.base },
    BlinkCmpLabelDescription = { link = "BlinkCmpLabelDetail" },
    BlinkCmpLabelMatch = { fg = colors.blue },
    -- BlinkCmpScrollBarThumb = { bg = colors.surface1 },

    -- BlinkCmpLabelMatch = { bg = default_bg, fg = colors.blue },

    -- CmpGhostText = { link = "Comment", default = true },
    -- CmpItemAbbrMatch = { fg = colors.yellow, underline = false },
    -- CmpItemAbbrMatchFuzzy = { fg = colors.blue, underline = true, link = "CmpItemAbbrMatch" },

    -- Pmenu = { bg = colors.base, fg = colors.text },
    -- PmenuBorder = { link = "FloatBorder" },
    -- PmenuDocBorder = { link = "FloatBorder" },
    -- PmenuSel = { bg = colors.surface0, bold = false },
    -- PopupNormal = { bg = colors.base, fg = colors.text },

    -- CursorLine = { bg = utils.darken(colors.surface0, 0.62) },
    -- CursorLine = { bg = default_bg },
    CursorLineNr = { fg = colors.subtext0 },
    CursorLineSign = { link = "SignColumn" },
    CursorColumn = { bg = default_bg },

    FlashLabel = { fg = colors.base, bg = colors.yellow, bold = true },

    GitSignsAdd = { fg = colors.green },
    GitSignsChange = { fg = colors.blue },

    NeogitDiffContextCursor = { bg = colors.surface0, fg = colors.text },
    NeogitSubtleText = { bg = default_bg, fg = colors.surface2, italic = false },
    NeogitFloatHeader = { bg = colors.mauve, fg = colors.base },

    -- NeoTreeCursorLine = { link = "PmenuSel" },
    -- NeoTreeIndentMarker = { fg = colors.surface2 },
    -- NeoTreeNormal = { bg = default_bg },
    -- NeoTreeNormalNC = { bg = default_bg },
    -- NeoTreePreview = { link = "NeoTreeNormal" },

    -- NoiceCmdlineIcon = { fg = colors.yellow, italic = false, bold = true },
    -- NoiceCmdlinePopup = { bg = default_bg, fg = colors.text },
    -- NoiceCmdlinePopupTitle = { bg = colors.red, fg = colors.text },
    -- NoiceCmdlinePopupBorder = { link = "FloatBorder" },
    -- NoiceCmdlinePopupTitleInput = { bg = colors.yellow, fg = colors.base },
    -- NoiceFormatLevelOff = { bg = colors.yellow },
    -- NoicePopupmenu = { bg = colors.mantle },
    -- NoicePopupmenuBorder = { link = "FloatBorder" },
    -- NoicePopup = { link = "NoicePopupmenu" },
    -- NoicePopupBorder = { link = "NoicePopup" },

    PopupBorder = { link = "FloatBorder" },
    -- PopupNormal = { bg = colors.base, fg = colors.mantle },

    SwitchBufferStatusColor = { fg = colors.red },

    -- SnacksPickerDir = { italic = true, fg = colors.overlay0 },
    -- SnacksPickerTitle = { bg = default_bg, fg = colors.text, italic = true, bold = true },
    SnacksDashboardHeader = { fg = colors.mauve },
    SnacksDashboardIcon = { fg = colors.mauve },
    SnacksDashboardDesc = { fg = colors.text },
    SnacksDashboardKey = { fg = colors.peach },
    SnacksDashboardFooter = { fg = colors.maroon },
    -- SnacksPickerBoxCursorLine = { link = "PmenuSel" },
    -- SnacksPickerListCursorLine = { link = "PmenuSel" },
    SnacksIndentScope = { fg = colors.surface1 },

    StatusLine = { fg = colors.text, bg = colors.base },
    StatusLineNC = { link = "StatusLine" },

    -- SnacksDashboardHeader = { fg = colors.yellow },

    DiagnosticUnnecessary = { fg = colors.overlay0 },

    -- TelescopeMatching = { link = "CmpItemAbbrMatch" },
    -- TelescopeTitle = { link = "FloatTitle" },
    -- TelescopeSelection = { link = "PmenuSel" },
    --
    -- TelescopePromptPrefix = { fg = colors.blue },
    -- TelescopePromptNormal = { bg = colors.base, fg = colors.text },
    -- -- TelescopePromptBorder = { bg = colors.base, fg = colors.surface0 },
    -- TelescopePromptBorder = { link = "FloatBorder" },
    -- TelescopePromptTitle = { link = "FloatTitle" },
    --
    -- TelescopeResultsNormal = { bg = colors.base, fg = colors.subtext1 },
    -- TelescopeResultsBorder = { link = "FloatBorder" },
    -- TelescopeResultsTitle = { bg = colors.blue, fg = colors.base },
    --
    -- TelescopePreviewBorder = { link = "FloatBorder" },
    -- TelescopePreviewNormal = { bg = colors.base },
    -- TelescopePreviewTitle = { link = "FloatTitle" },

    -- FzfLuaNormal = { bg = colors.base, fg = colors.text },
    -- FzfPreviewTitle = { fg = colors.text, italic = true },
    -- FzfLuaPreviewTitle = { fg = colors.base, italic = true },
    -- FzfLuaBorder = { link = "FloatBorder" },
    -- FzfLuaBackdrop = { bg = default_bg },

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

    -- StatusLineNC = { fg = colors.surface0 },
    -- StatusLine = { fg = colors.surface0 },

    EdgyNormal = { bg = colors.base },
    EdgyWinBar = { bg = colors.surface0, fg = "None" },
    -- EdgyTitle = { bg = colors.surface0, fg = colors.blue },
    -- EdgyIconActive = { bg = colors.surface0, fg = colors.peach },
    EdgyTitle = { bg = colors.surface0, fg = colors.blue },
    EdgyIconActive = { bg = colors.surface0, fg = colors.peach },

    HighlightUndo = { bg = colors.red, fg = colors.base },
    HighlightRedo = { bg = colors.green, fg = colors.base },

    -- AlphaHeader = { fg = colors.yellow, bold = true },
    -- AlphaNeovimLogoMauve = { fg = colors.mauve },
    -- AlphaNeovimLogoBlue = { fg = colors.blue },
    -- AlphaNeovimLogoGreen = { fg = colors.green },
    -- AlphaNeovimLogoGreenFBlueB = { fg = colors.green, bg = colors.blue },

    -- RenderMarkdownChecked = { fg = colors.green },
    -- RenderMarkdownTodo = { fg = colors.blue },
    -- RenderMarkdownPending = { fg = colors.blue },
    --
    -- RenderMarkdownH1 = { fg = colors.red, bg = utils.darken(colors.red, darken_markdown_heading) },
    -- RenderMarkdownH2 = {
    --   fg = colors.peach,
    --   bg = utils.darken(colors.peach, darken_markdown_heading),
    -- },
    -- RenderMarkdownH3 = {
    --   fg = colors.yellow,
    --   bg = utils.darken(colors.yellow, darken_markdown_heading),
    -- },
    -- RenderMarkdownH4 = {
    --   fg = colors.green,
    --   bg = utils.darken(colors.green, darken_markdown_heading),
    -- },
    -- RenderMarkdownH5 = { fg = colors.blue, bg = utils.darken(colors.blue, darken_markdown_heading) },
    -- RenderMarkdownH6 = {
    --   fg = colors.mauve,
    --   bg = utils.darken(colors.mauve, darken_markdown_heading),
    -- },
    --
    -- RenderMarkdownH1Bg = { link = "RenderMarkdownH1" },
    -- RenderMarkdownH2Bg = { link = "RenderMarkdownH2" },
    -- RenderMarkdownH3Bg = { link = "RenderMarkdownH3" },
    -- RenderMarkdownH4Bg = { link = "RenderMarkdownH4" },
    -- RenderMarkdownH5Bg = { link = "RenderMarkdownH5" },
    --
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
    -- CopilotChatSeparator = { fg = colors.surface1 },

    -- === Lsp
    ["@keyword.operator.python"] = { link = "Conditional" },
  }
end

function M.override_hl(colors_table)
  local colors = M.get(colors_table)

  for hl, col in pairs(colors) do
    vim.api.nvim_set_hl(0, hl, col)
  end
end

function M.override_lsp_hl(colors_table)
  local colors = colors_table

  vim.api.nvim_set_hl(0, "@keyword.operator.python", { link = "Conditional" })
end

return M
