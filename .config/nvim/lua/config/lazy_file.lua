local M = {}

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

function M.lazy_file()
	-- Add support for the LazyFile event
	local Event = require("lazy.core.handler.event")

	Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
	Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

return M
