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
		'saghen/blink.cmp',
		dependencies = 'rafamadriz/friendly-snippets',
		version = '*',
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = 'default' },
			signature = { enabled = true },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'mono'
			},
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},
		},
		opts_extend = { "sources.default" }
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			{ -- make lsp experience for nvim config itself better
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			},
		},
		config = function()
			local lspconfig = require('lspconfig')
			local capabilities = require('blink.cmp').get_lsp_capabilities()

			--setup lsp servers
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
					"tinymist"
				},
				handlers = {
					function(server_name) -- default handler (auto provides our capabilities)
						require("lspconfig")[server_name].setup {
							capabilities = capabilities
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
				},
			}) -- end mason-lspconfig setup

			-- manual server install
			lspconfig.harper_ls.setup{
				filetypes = {
					'html',
					'typst',
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
			lspconfig.superhtml.setup {
				filetypes = { 'superhtml', 'html' }
			}
			lspconfig.clangd.setup {}
			lspconfig.gleam.setup {}
			lspconfig.denols.setup {}
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
