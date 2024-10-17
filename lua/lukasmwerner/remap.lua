vim.g.mapleader = " "

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
--vim.keymap.set("n", "<leader>c", ":set background=light<CR>")
vim.keymap.set("n", "<leader>c", function()
	if vim.opt.background:get() == "dark" then
		vim.opt.background = "light"
	else
		vim.opt.background = "dark"
	end
end)
--vim.keymap.set("n", "<leader>w", function() require("trouble").toggle() end)

vim.keymap.set("x", "<leader>p>", "\"_dP")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "gni", vim.diagnostic.goto_next)
vim.keymap.set("n", "gpi", vim.diagnostic.goto_prev)
