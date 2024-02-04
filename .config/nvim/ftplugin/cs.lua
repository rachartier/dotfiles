vim.b.dispatch = "dotnet test"
vim.g.compiler = "dotnet_build"

local makeprg_builder = "dotnet clean --verbosity:quiet --nologo "
makeprg_builder = makeprg_builder
	.. "&& dotnet build --nologo --verbosity:quiet --consoleLoggerParameters:NoSummary --consoleLoggerParameters:GenerateFullPaths-true"

vim.o.makeprg = makeprg_builder

vim.o.errorformat = "%f(%l\\,%v): %t%*[^:]: %m,%trror%*[^:]: %m,%tarning%*[^:]: %m"
