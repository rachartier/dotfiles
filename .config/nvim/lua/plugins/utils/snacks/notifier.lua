local signs = require("config.ui.signs").full_diagnostic

return {
  enabled = true,
  style = "minimal",
  top_down = false,
  icons = {
    error = signs.error,
    warn = signs.warning,
    info = signs.info,
    trace = signs.hint,
  },
}
