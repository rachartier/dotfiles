local utils = require("new-file-template.utils")

-- For the users
local function new_file_template_for_user(_, _)
    return [=[
local utils = require("new-file-template.utils")

local function base_template(relative_path, filename)
  return [[
|cursor|
  ]]
end

--- @param opts table
---   A table containing the following fields:
---   - `full_path` (string): The full path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `relative_path` (string): The relative path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `filename` (string): The filename of the new file, e.g., "init.lua".
return function(opts)
  local template = {
    { pattern = ".*", content = base_template },
  }

	return utils.find_entry(template, opts)
end]=]
end

local function plugin_template(relative_path, filename)
    return [[
local M = {
    "|cursor|"
}

function M.config()

end

return M
  ]]
end

local function base_template(relative_path, filename)
    return [[|cursor|]]
end

--- @param opts table
---   A table containing the following fields:
---   - `full_path` (string): The full path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `relative_path` (string): The relative path of the new file, e.g., "lua/new-file-template/templates/init.lua".
---   - `filename` (string): The filename of the new file, e.g., "init.lua".
return function(opts)
    local template = {
        { pattern = "lua/templates/.*", content = new_file_template_for_user },
        { pattern = "lua/plugins/.*",   content = plugin_template },
        { pattern = ".*",               content = base_template },
    }

    return utils.find_entry(template, opts)
end
