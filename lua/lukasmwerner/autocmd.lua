local autocmd = vim.api.nvim_create_autocmd

autocmd('LspAttach', {
	callback = function (e)
		local opts = {buffer = e.buf, remap = false}
		vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		--vim.keymap.set("n", "fr", function() vim.lsp.buf.references() end, opts)
		vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
		vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
		vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
		--vim.keymap.set("n", "<leader>a", function() vim.lsp.buf.code_action() end, opts)
		vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
		vim.keymap.set("n", "<leader>cf", function ()
		end, opts)

		local client = vim.lsp.get_client_by_id(e.data.client_id)
		if not client then return end

		if client.supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				buffer = e.buf,
				callback = function ()
					vim.lsp.buf.format({bufnr = e.buf, id = client.id})
				end
			})
		end
	end,
})

-- Trailing whitespace visualization
vim.api.nvim_set_hl(0, 'TrailingWhitespace', { bg='#E67E80' })
autocmd('BufEnter', {
	pattern = '*',
	command = [[
		syntax clear TrailingWhitespace |
		syntax match TrailingWhitespace "\_s\+$"
	]]}
)


