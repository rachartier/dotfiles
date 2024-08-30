local M = {}

local curl = require("plenary.curl")
local Path = require("plenary.path")

M.vim_version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch

M.copilot_token = nil
M.github_token = nil

function M.find_config_path()
	local config_paths = {
		vim.fn.expand("$XDG_CONFIG_HOME"),
		vim.fn.expand("~/.config"),
	}

	if vim.fn.has("win32") == 1 then
		table.insert(config_paths, vim.fn.expand("$APPDATA"))
	end

	for _, config in ipairs(config_paths) do
		if vim.fn.isdirectory(config) > 0 then
			return config
		end
	end
end

function M.validate_copilot_api_token()
	if not M.copilot_token or (M.copilot_token.expires_at and M.copilot_token.expires_at <= math.floor(os.time())) then
		curl.get("https://api.github.com/copilot_internal/v2/token", {
			timeout = 5000,
			headers = {
				["Authorization"] = "token " .. M.github_token,
				["Accept"] = "application/json",
				["editor-version"] = "Neovim/" .. M.vim_version,
			},
			on_error = function(err)
				error("Failed to get response: " .. vim.inspect(err))
			end,
			callback = function(output)
				M.copilot_token = vim.json.decode(output.body)
			end,
		})
	end
end

function M.get_github_token()
	local config_path = M.find_config_path()
	if not config_path then
		return nil
	end

	local file_paths = {
		config_path .. "/github-copilot/hosts.json",
		config_path .. "/github-copilot/apps.json",
	}

	for _, file_path in ipairs(file_paths) do
		if vim.fn.filereadable(file_path) == 1 then
			local creds = vim.json.decode(Path:new(file_path):read() or "{}")
			for k, v in pairs(creds) do
				if k:find("github.com") then
					return v.oauth_token
				end
			end
		end
	end

	return nil
end

function M.setup()
	M.github_token = M.get_github_token()

	if not M.github_token then
		error(
			"No GitHub token found, please use `:Copilot auth` to setup with `copilot.lua` or `:Copilot setup` with `copilot.vim`"
		)
	end

	M.validate_copilot_api_token()
end

return M
