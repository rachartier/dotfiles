vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == "ruff" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = "disable hover capability from ruff",
})

return {
  root_marker = {
    "main.py",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
}
