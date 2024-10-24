return {
	{
		"j-hui/fidget.nvim",
		opts = {},
		lazy = false,
	},
	{
		"luckasRanarison/clear-action.nvim",
		opts = {
			signs = {
				enable = false,
			},
			popup = {
				border = "none",
				highlights = {},
			},
			mappings = {
				code_action = "<leader>a",
			},
		}
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require('cmp')
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities())

			--setup lsp servers
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
				},
				handlers = {
					function(server_name) -- default handler (auto provides our capabilities)
						require("lspconfig")[server_name].setup {
							capabilities = capabilities
						}
					end,
					["lua_ls"] = function() -- lua handler fix the config for vim
						local lspconfig = require("lspconfig")
						lspconfig.lua_ls.setup {
							capabilities = capabilities,
							settings = {
								Lua = {
									runtime = { version = "Lua 5.1" },
									diagnostics = {
										globals = { "vim", "it", "describe", "before_each", "after_each" },
									}
								}
							}
						}
					end,
					["html"] = function ()
						local lspconfig = require("lspconfig")
						lspconfig.html.setup {
							capabilities = capabilities,
							filetypes = { "html", "templ" },
						}
					end,
					["htmx"] = function ()
						local lspconfig = require("lspconfig")
						lspconfig.htmx.setup {
							capabilities = capabilities,
							filetypes = { "html", "templ" },
						}
					end,
					["tailwindcss"] = function ()
						local lspconfig = require("lspconfig")
						lspconfig.tailwindcss.setup({
							capabilities = capabilities,
							filetypes = { "templ", "astro", "javascript", "typescript", "react" },
							init_options = { userLanguages = { templ = "html" } },
						})
					end,
				},
			}) -- end mason-lspconfig setup

			-- manual server install
			local lspconfig = require("lspconfig")
			lspconfig.harper_ls.setup{
				filetypes = {
					'html',
					'gitcommit',
					'markdown',
					'rust',
					'typescript',
					'typescriptreact',
					'javascript',
					'python',
					'go',
					'c',
					'cpp',
					'ruby',
					'swift',
					'csharp',
					'toml',
					'lua',
					'mail',
				},
			}
			require'lspconfig'.superhtml.setup {
				filetypes = { 'superhtml', 'html' }
			}
			lspconfig.clangd.setup {}
			lspconfig.gleam.setup {}
			lspconfig.gopls.setup {
				filetypes = {
					"go",
					"gomod",
					"gowork",
					"gotmpl",
					"tmpl",
				},
				templateExtensions = {
					"tmpl",
					"tmpl.html",
					"gotmpl"
				},
			}

			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{name = 'nvim_lsp'},
					{ name = 'luasnip'},
				}, {
						{name = 'buffer' },
					}),
			})

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = false,
				underline = true,
				severity_sort = true,
				float = true,
			})

		end,
	},
	{
		-- TODO: we need to fix this
		'sbdchd/neoformat',
		config = function ()
			vim.api.nvim_create_autocmd({'BufWritePre'}, {
				pattern = {'*'},
				callback = function (ev)
					-- Get the current buffer's file name
					local bufname = vim.api.nvim_buf_get_name(ev.buf)

					-- Ensure UNIX file format
					vim.api.nvim_command('set ff=unix')

					-- Check if the file ends with ".slides.md"
					if string.match(bufname, "%.slides%.md$") then
						return
					end

					-- Otherwise run neoformat aka lsp formatter on the buffer
					vim.api.nvim_command('undojoin')
					vim.api.nvim_command('Neoformat')
				end,
			})
		end,
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>w",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
			"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
			"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
}
