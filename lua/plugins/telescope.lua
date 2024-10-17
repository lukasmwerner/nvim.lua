return {
	'nvim-telescope/telescope.nvim', branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons',
	},
	config = function ()
		local builtin = require('telescope.builtin')
		local wk = require("which-key")
		vim.keymap.set('n', "<leader>fr", builtin.lsp_references, { desc = "Find References", })
    	vim.keymap.set('n', "<leader>ff", builtin.find_files,     { desc = "Find Files", })
    	vim.keymap.set('n', "<leader>fg", builtin.live_grep,      { desc = "Grep Files", })
    	vim.keymap.set('n', "<leader>fh", builtin.help_tags,      { desc = "Help Tags",  })
	end,
}
