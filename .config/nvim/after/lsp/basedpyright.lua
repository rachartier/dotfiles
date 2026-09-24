return {
  root_markers = {
    "main.py",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typecheckingMode = "basic",
      },
    },
  },
}
