return {
	{
		'chomosuke/typst-preview.nvim',
		ft = 'typst',
		version = '1.*',
		config = function()
			require 'typst-preview'.setup {}
		end,
	},
	{
		'nvim-mini/mini.ai',
		version = false,
		ft = 'typst',
		config = {},
	},
}
