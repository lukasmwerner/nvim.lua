return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function ()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "markdown", "markdown_inline", "c", "lua", "vim", "vimdoc", "query", "elixir", "go", "javascript", "html", "gleam", "rust", "templ"},
			sync_install = false,
			auto_install = true,
			highlight = {
				additional_vim_regex_highlighting = false,
				enable = true,
			},
			indent = { enable = true },
		})
	end,
}
