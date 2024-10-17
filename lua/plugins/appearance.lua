return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		lazy = false,
		opts = {},
	},
	{
		'alvarosevilla95/luatab.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		lazy = false,
		opts = {},
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				width = .85,
				options = {
					number = false,
					relativenumber = false,
				},
			},
		}
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		opts = {
		},
	},
}
