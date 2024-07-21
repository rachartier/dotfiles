return {
	"RRethy/vim-illuminate",
	event = { "LazyFile" },
	config = function()
		require("illuminate").configure()
	end,
}
