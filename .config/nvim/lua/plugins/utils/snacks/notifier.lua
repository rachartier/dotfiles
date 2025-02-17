local signs = require("config.ui.signs").full_diagnostic

return {
	enabled = true,
	icons = {
		error = signs.error,
		warn = signs.warning,
		info = signs.info,
		trace = signs.hint,
	},
}
