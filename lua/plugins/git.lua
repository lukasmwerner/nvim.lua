return {
    {
		"sindrets/diffview.nvim",
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		cmd = "DiffviewOpen",
		keys = {
			{ "<leader>di", "<cmd>:DiffviewOpen<CR>", desc="Show Git Diff" },
		},
	}
}
