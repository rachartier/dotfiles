local loaded = false

local function load()
  if loaded then
    return
  end
  loaded = true

  vim.pack.add({ "https://github.com/uhs-robert/sshfs.nvim" }, { confirm = false })

  require("sshfs").setup({
    mounts = {
      base_dir = "/tmp/sshfs",
    },
    host_paths = {
      ["kirby-server"] = { "/srv" },
    },
    ui = {
      file_picker = {
        preferred_picker = "mini",
        fallback_to_netrw = false,
      },
      live_remote_picker = {
        preferred_picker = "mini",
      },
    },
  })
end

local function create_cmd(name)
  vim.api.nvim_create_user_command(name, function(info)
    load()
    vim.api.nvim_del_user_command(name)
    vim.cmd(name .. (info.args ~= "" and " " .. info.args or ""))
  end, { nargs = "?" })
end

for _, cmd in ipairs({ "SSHConnect", "SSHDisconnect", "SSHConfig", "SSHReload", "SSHFiles", "SSHGrep", "SSHLiveFind", "SSHLiveGrep", "SSHExpl" }) do
  create_cmd(cmd)
end

local key_to_cmd = {
  ["<leader>mm"] = "SSHConnect",
  ["<leader>mu"] = "SSHDisconnect",
  ["<leader>me"] = "SSHExpl",
  ["<leader>md"] = "SSHFiles",
  ["<leader>mo"] = "SSHFiles",
  ["<leader>mc"] = "SSHConfig",
  ["<leader>mr"] = "SSHReload",
  ["<leader>mf"] = "SSHLiveFind",
  ["<leader>mg"] = "SSHLiveGrep",
  ["<leader>mt"] = "SSHGrep",
}

for key, cmd in pairs(key_to_cmd) do
  vim.keymap.set("n", key, function()
    load()
    vim.cmd(cmd)
  end, { silent = true, desc = cmd })
end
