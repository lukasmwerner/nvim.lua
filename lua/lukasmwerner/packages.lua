return {
	{
		"sainnhe/everforest",
		lazy = false,
		priority = 1000,
		config = function()
			-- load the colorscheme here
			vim.cmd("set termguicolors")
			--vim.cmd("set background=") -- can also be light / dark
			vim.cmd("let g:everforest_background = 'medium'")
			vim.cmd([[colorscheme everforest]])
		end,

	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		lazy = false,
		config = function ()
			require('lualine').setup()
		end,
	},
	{
		'alvarosevilla95/luatab.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		lazy = false,
		config = function ()
			require('luatab').setup()
		end,
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
	{ "folke/neoconf.nvim", cmd = "Neoconf" },
	"folke/neodev.nvim",
	{
		'nvim-telescope/telescope.nvim', branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		-- keys = {
		-- 	{"<leader>ff", require("telescope.builtin").find_files, desc="Find Files"},
		-- 	{"<leader>fg", require("telescope.builtin").live_grep,  desc="Grep Files"},
		-- 	{"<leader>fh", require("telescope.builtin").help_tags,  desc="Help Tags"},
		-- },
	},
	{
		'nvim-tree/nvim-tree.lua',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {},

		keys = {
			{
				"<leader>fb",
				"<cmd>NvimTreeToggle<cr>",
				desc = "Toggle File Browser (NvimTree)",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function ()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "go", "javascript", "html", "gleam", "rust" },
				sync_install = false,
				auto_install = true,
				highlight = {
					additional_vim_regex_highlighting = false,
					enable = true,
				},
				indent = { enable = true },
			})

			local treesitter_parser_config = require "nvim-treesitter.parsers".get_parser_configs()
			treesitter_parser_config.templ = {
				install_info = {
					url = "https://github.com/vrischmann/tree-sitter-templ.git",
					files = {"src/parser.c", "src/scanner.c"},
					branch = "master",
				},
			}
			vim.treesitter.language.register('templ', 'templ')

		end,
	},
	{ -- LSP status messages
		"j-hui/fidget.nvim",
		opts = {},
	},
	{ -- Small menu for LSP actions 
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
			lspconfig.clangd.setup {}
			lspconfig.gleam.setup {}

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
		cmd = 'Neoformat',
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
		"mbbill/undotree",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<cr>" },
		},
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>w",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		cmd = "DiffviewOpen",
		keys = {
			{ "<leader>di", "<cmd>:DiffviewOpen<CR>", desc="Show Git Diff" },
		},
	}
}
