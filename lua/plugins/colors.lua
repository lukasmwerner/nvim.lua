return {
	"sainnhe/everforest",
	lazy = false,
	priority = 1000,
	config = function()
		-- load the colorscheme here
		vim.cmd("set termguicolors")
		vim.cmd("set background=light") -- can also be light / dark
		vim.cmd("let g:everforest_background = 'medium'")
		vim.cmd([[colorscheme everforest]])
	end,
}
