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
			"giuxtaposition/blink-cmp-copilot",
			"mikavilpas/blink-ripgrep.nvim",
			"moyiz/blink-emoji.nvim",
		},
		version = '*',
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			keymap = { preset = 'default' },
			signature = { enabled = true },
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = 'mono',
				kind_icons = {
					Ollama = '',
					gemini = '',
					ripgrep = ''
				},
			},
			sources = {
				default = { 'emoji', 'lsp', 'path', 'snippets', 'buffer', 'ripgrep', 'minuet' },
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
					ripgrep = {
						module = "blink-ripgrep",
						name = "Ripgrep",
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								-- example: append a description to easily distinguish rg results
								item.labelDetails = {
									description = "(rg)",
								}
								item.kind_name = 'ripgrep'
							end
							return items
						end,
					},
					minuet = {
						name = 'minuet',
						module = 'minuet.blink',
						score_offset = 2,
					},
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						async = true,
					},
				},
			},
		},
		opts_extend = { "sources.default" }
	},
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			require("blink.cmp").setup({
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
			})
		end
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
					["html"] = function()
						local lspconfig = require("lspconfig")
						lspconfig.html.setup {
							capabilities = capabilities,
							filetypes = { "html", "templ" },
						}
					end,
					["htmx"] = function()
						local lspconfig = require("lspconfig")
						lspconfig.htmx.setup {
							capabilities = capabilities,
							filetypes = { "html", "templ" },
						}
					end,
				},
			}) -- end mason-lspconfig setup

			-- manual server install
			lspconfig.harper_ls.setup {
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
			lspconfig.templ.setup {}
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
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
				filetypes = { "templ", "astro", "javascript", "typescript", "react" },
				settings = {
					tailwindCSS = {
						includeLanguages = {
							templ = "html",
						},
					},
				},
			})


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
