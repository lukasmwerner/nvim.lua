return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
	{

		'milanglacier/minuet-ai.nvim',
		config = function()
			require('minuet').setup {
				--provider = 'openai_fim_compatible',
				provider = 'gemini',
				n_completions = 1, -- recommend for local model for resource saving
				-- I recommend beginning with a small context window size and incrementally
				-- expanding it, depending on your local computing power. A context window
				-- of 512, serves as an good starting point to estimate your computing
				-- power. Once you have a reliable estimate of your local computing power,
				-- you should adjust the context window to a larger value.
				context_window = 512,
				provider_options = {
					openai_fim_compatible = {
						api_key = 'TERM',
						name = 'Ollama',
						end_point = 'http://localhost:11434/v1/completions',
						model = 'qwen2.5-coder:3b',
						optional = {
							max_tokens = 56,
							top_p = 0.9,
						},
					},
					gemini = {
						model = 'gemini-2.0-flash',
						stream = true,
						api_key = 'GEMINI_API_KEY',
						optional = {},
					},
					openai_compatible = {
						model = 'llama-3.3-70b-versatile',
						end_point = 'https://api.groq.com/openai/v1/chat/completions',
						api_key = 'GROQ_API_KEY',
						name = 'Groq',
						stream = true,
						optional = {
							stop = nil,
							max_tokens = nil,
						},
					}
				},
			}
		end,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'Saghen/blink.cmp',
			'nvim-lualine/lualine.nvim',
		},
	},
	{
		"giuxtaposition/blink-cmp-copilot",
	}
}
