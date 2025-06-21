return {
  settings = {
    root_dir = function(fname)
      return require("lspconfig.util").root_pattern("*.sln", "*.csproj")(fname)
    end,
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = true,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true,
        EnableImportCompletion = true,
      },
      Sdk = {
        IncludePrereleases = true,
      },
    },
  },
}
