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
		dependencies = {
			'rafamadriz/friendly-snippets',
			"moyiz/blink-emoji.nvim",
			"xzbdmw/colorful-menu.nvim",
		},
		version = '*',
		---@module 'blink.cmp'
		---@type blink.cmp.Config

		opts = {
			keymap = { preset = 'default' },
			signature = { enabled = true },
			sources = {
				default = { 'emoji', 'lsp', 'path', 'snippets', 'buffer' },
				providers = {
					emoji = {
						module = "blink-emoji",
						name = "Emoji",
						score_offset = 15,
						opts = { insert = true }, -- Insert emoji (default) or complete its name
						should_show_items = function()
							return vim.tbl_contains(
							-- Enable emoji completion only for git commits and markdown.
							-- By default, enabled for all file-types.
								{ "gitcommit", "markdown" },
								vim.o.filetype
							)
						end,
					},
				},
			},
			completion = {
				menu = {
					draw = {
						-- We don't need label_description now because label and label_description are already
						-- combined together in label by colorful-menu.nvim.
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
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
			{   -- make lsp experience for nvim config itself better
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
			local capabilities = require('blink.cmp').get_lsp_capabilities()

			--setup lsp servers
			require("mason").setup()
			require("mason-lspconfig").setup({
				automatic_installation = false,
				ensure_installed = {
					"lua_ls",
					"tinymist",
					"gopls",
				},
				automatic_enable = false,
			}) -- end mason-lspconfig setup

			-- manual server install
			vim.lsp.config.harper_ls = {
				settings = {
					["harper-ls"] = {
						linters = {
							ToDoHyphen = false,
						},
					},
				},
				-- cmd = vim.lsp.rpc.connect("127.0.0.1", 4000),
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
			vim.lsp.config.gopls = {
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
			vim.lsp.config.tailwindcss = {
				capabilities = capabilities,
				filetypes = { "templ", "astro", "javascript", "typescript", "react", "svelte" },
				settings = {
					tailwindCSS = {
						includeLanguages = {
							templ = "html",
						},
					},
				},
			}

			vim.lsp.enable({
				'harper_ls',
				'lua_ls',
				'rust_analyzer',
				'clangd',
				'gleam',
				'gopls',
				'tinymist',
				-- Web Tech
				'ts_ls',
				'superhtml',
				'templ',
				'tailwindcss',
				'svelte',

				-- Python
				'pylsp',
				--'ruff',
				--'basedpyright',
			})

			--lspconfig.htmx.setup {}
			-- lspconfig.denols.setup {}

			vim.diagnostic.config({
				--virtual_text = true,
				virtual_lines = true, -- This one is better than virtual_text IMHO
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
