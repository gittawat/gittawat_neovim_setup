return {
	'VonHeikemen/lsp-zero.nvim',
	branch = 'v3.x',
	dependencies = {
		-- LSP Support
		{ 'neovim/nvim-lspconfig' }, -- Required
		{
			"williamboman/mason.nvim",
			build = ":MasonUpdate"         -- :MasonUpdate updates registry contents
		},
		{ 'williamboman/mason-lspconfig.nvim' }, -- Optional

		-- Autocompletion
		{ 'hrsh7th/nvim-cmp' }, -- Required
		{ 'hrsh7th/cmp-nvim-lsp' }, -- Required
		{ 'L3MON4D3/LuaSnip' }, -- Required
	},
	config = function()
		local lsp_z = require("lsp-zero")
		lsp_z.set_sign_icons({
			error = 'E',
			warn = 'W',
			hint = 'H',
			info = 'I',
		})

		lsp_z.nvim_lua_ls()

		lsp_z.on_attach(function(client, bufnr)
			local opts = { buffer = bufnr, remap = false }
			lsp_z.default_keymaps({
				buffer = bufnr,
				preserve_mappings = false
			})
			--vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
			--vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
			vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
			vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
			vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
			vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
			vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
			vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
			vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
			vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
		end)

		require('mason').setup({})
		require('mason-lspconfig').setup({
			handlers = {
				lsp_z.default_setup,
				lua_ls = function()
					local lua_opts = lsp_z.nvim_lua_ls()
					require('lspconfig').lua_ls.setup(lua_opts)
				end,
			}
		})

		lsp_z.setup()

		local cmp = require('cmp')
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			sources = {
				{ name = 'path' },
				{ name = 'nvim_lsp' },
				{ name = 'nvim_lua' },
			},
			formmating = lsp_z.cmp_format(),
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm { select = false },
				['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
				['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				['<Tab>'] = nil,
				['<S-Tab>'] = nil,
			})
		})


		require('lspconfig').bashls.setup {}
		require('lspconfig').pylsp.setup {
			settings = {
				pylsp = {
					plugins = {
						ruff = {
							enabled = true, -- Enable the plugin
						}
					}
				}
			}
		}
		require('lspconfig').openscad_lsp.setup {}
		require('lspconfig').zls.setup {}
		require('lspconfig').clangd.setup {}


		vim.diagnostic.config({
			virtual_text = true
		})
	end
}