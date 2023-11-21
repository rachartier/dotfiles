local utils = require("new-file-template.utils")

local function main_template(relative_path, filename)
    return [[

def main():
    |cursor|

if __name__ == "__main__":
    main()
  ]]
end

local function class_template(relative_path, filename)
    local name = vim.split(filename, "%.")[1]

    return [[
class ]] .. utils.snake_to_class_camel(name) .. [[:
    def __init__(self) -> None:
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
        { pattern = "main.py", content = main_template },
        { pattern = ".*",      content = class_template },
    }

    return utils.find_entry(template, opts)
end
