return {
	{ "folke/neoconf.nvim", cmd = "Neoconf", opts = {}},
	"folke/neodev.nvim",
	{
		'nvim-tree/nvim-tree.lua',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {},
		keys = {
			{
				"<leader>fb",
				function() require("nvim-tree.api").tree.toggle() end,
				desc = "File Tree/Browser"
			}
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{ 'glacambre/firenvim', build = ":call firenvim#install(0)" },
}
