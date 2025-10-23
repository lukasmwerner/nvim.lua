local function wordcount()
    return tostring(vim.fn.wordcount().words) .. ' words'
end

local function readingtime()
	return tostring(math.ceil(vim.fn.wordcount().words / 200.0)) .. ' min'
end

local function is_markdown()
    return vim.bo.filetype == "markdown" or vim.bo.filetype == "asciidoc"
end


return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', 'milanglacier/minuet-ai.nvim' },
		lazy = false,
		opts = {
			sections = {
				lualine_x = {
					--require('minuet.lualine'),
					{ readingtime,   cond = is_markdown },
					{ wordcount,   cond = is_markdown },
					'encoding',
					'fileformat',
					'filetype',
				},
			},
		},
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
