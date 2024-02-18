local M = {
	"huynle/ogpt.nvim",
	event = "VeryLazy",
	opts = {
		default_provider = "ollama",
		providers = {
			providers = {
				ollama = {
					api_host = os.getenv("OLLAMA_API_HOST") or "http://localhost:11434",
					api_key = os.getenv("OLLAMA_API_KEY") or "",
				},
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	enabled = false,
}

return M
