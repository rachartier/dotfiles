return {
  "seblyng/roslyn.nvim",
  ft = { "cs", "vb" },
  opts = {
    -- NOTE: Set `filewatching` to false if you experience performance problems.
    -- Defaults to true, since turning it off is a hack.
    -- If you notice that the server is _super_ slow, it is probably because of file watching
    -- I noticed that neovim became super unresponsive on some large codebases, and that was because
    -- it schedules the file watching on the event loop.
    -- This issue went away by disabling that capability. However, roslyn will fallback to its own
    -- file watching, which can make the server super slow to initialize.
    -- Setting this option to false will indicate to the server that neovim will do the file watching.
    -- However, in `hacks.lua` I will also just don't start off any watchers, which seems to make the server
    -- a lot faster to initialize.
    filewatching = "auto",
  },
  config = function(_, opts)
    require("roslyn").setup(opts)
  end,
}
