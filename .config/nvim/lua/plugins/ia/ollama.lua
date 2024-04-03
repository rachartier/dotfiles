local model = "deepseek-coder:6.7b"

return {
	"David-Kunz/gen.nvim",
	enabled = false,
	opts = {
		display_mode = "split",
		model = model, -- The default model to use.
		host = "192.168.1.160", -- The host running the Ollama service.
		port = "11434", -- The port on which the Ollama service is listening.
		show_prompt = true, -- Shows the Prompt submitted to Ollama.
		show_model = true, -- Displays which model you are using at the beginning of your chat session.
		no_auto_close = false, -- Never closes the window automatically.
		init = function(options)
			-- pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
		end,
		-- Function to initialize Ollama
		command = function(options)
			local body = { model = options.model, stream = true }
			return "curl --silent --no-buffer -X POST http://"
				.. options.host
				.. ":"
				.. options.port
				.. "/api/chat -d $body"
		end,
		debug = false, -- Prints errors and the command which is run.
	},
	config = function()
		local gen = require("gen")

		gen.prompts["Optimize"] = {
			prompt = "Optimize the following code to be more concise and readable.\n"
				.. "The user provided the additional info about how they would like you to respond:\n"
				.. "- If you're unsure don't guess and say you don't know instead.\n"
				.. "- Ask question if you need clarification to provide better answer.\n"
				.. "- Think deeply and carefully from first principles step by step.\n"
				.. "- Zoom out first to see the big picture and then zoom in to details.\n"
				.. "- Use Socratic method to improve your thinking and coding skills.\n"
				.. "- Don't elide any code from your output if the answer requires coding.\n"
				.. "- Take a deep breath; You've got this!\n"
				.. "Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
			replace = true,
			extract = "```$filetype\n(.-)```",
		}
	end,
}
