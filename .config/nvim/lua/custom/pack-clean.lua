-- ponytail: matches installed plugins against config sources, not session
-- `active` state, so lazy-added plugins (blink, dap, ...) are never flagged.
vim.api.nvim_create_user_command("PackClean", function()
  local config_dir = vim.fn.stdpath("config")
  local sources = table.concat(
    vim.fn.systemlist({
      "grep",
      "-rh",
      "github.com/",
      config_dir .. "/lua",
      config_dir .. "/plugin",
      config_dir .. "/after",
      config_dir .. "/init.lua",
    }),
    "\n"
  )

  local orphans = {}
  for _, p in ipairs(vim.pack.get()) do
    local repo = p.spec.src:gsub("^https://github.com/", ""):gsub("%.git$", "")
    if not sources:find(repo, 1, true) then
      table.insert(orphans, p.spec.name)
    end
  end

  if #orphans == 0 then
    vim.notify("PackClean: nothing to remove")
    return
  end

  local choice = vim.fn.confirm(
    "Remove " .. #orphans .. " unreferenced plugin(s)?\n" .. table.concat(orphans, "\n"),
    "&Yes\n&No"
  )
  if choice == 1 then
    vim.pack.del(orphans)
    vim.notify("PackClean: removed " .. table.concat(orphans, ", "))
  end
end, { desc = "remove installed plugins no longer referenced in config" })
