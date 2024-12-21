return {
	"sainnhe/everforest",
	lazy = false,
	priority = 1000,
	config = function()
		-- load the colorscheme here
		vim.cmd("set termguicolors")
		if vim.env.system_appearance then
			local appearance = vim.env.system_appearance:lower()
			print(appearance)
			vim.cmd("set background=" .. appearance)
		else
			vim.cmd("set background=light") -- can also be light / dark
		end
		vim.cmd("let g:everforest_background = 'medium'")
		vim.cmd([[colorscheme everforest]])
	end,
}
