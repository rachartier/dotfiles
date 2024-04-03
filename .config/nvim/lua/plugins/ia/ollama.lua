return {
	"David-Kunz/gen.nvim",
	enabled = true,
	config = function()
		local model = "pxlksr/opencodeinterpreter-ds:6.7b-Q4_K"
		require("gen").setup({
			display_mode = "split",
			model = model, -- The default model to use.
			host = "localhost", -- The host running the Ollama service.
			port = "11434", -- The port on which the Ollama service is listening.
			show_prompt = true, -- Shows the Prompt submitted to Ollama.
			show_model = true, -- Displays which model you are using at the beginning of your chat session.
			no_auto_close = false, -- Never closes the window automatically.
			init = function(options)
				pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
			end,
			-- Function to initialize Ollama
			command = function(options)
				local body = { model = model, stream = true }
				return "curl --silent --no-buffer -X POST http://"
					.. options.host
					.. ":"
					.. options.port
					.. "/api/chat -d $body"
			end,
			debug = false, -- Prints errors and the command which is run.
		})
	end,
}
