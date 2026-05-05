return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Configure servers (this loads nvim-lspconfig's configs automatically)
			vim.lsp.config("lua_ls", { capabilities = capabilities })
			vim.lsp.config("clangd", { capabilities = capabilities })

			-- Enable servers (they auto-attach to matching filetypes)
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("clangd")

			-- Global LSP keymaps
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
		end,
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = { "LspAttach", "BufReadPost", "BufNewFile" },
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "powerline",

				options = {
					show_source = {
						enabled = true,
					},

					add_messages = {
						display_count = true,
					},

					multilines = {
						enabled = true,
						always_show = true,
					},
				},
			})

			-- IMPORTANT: correct diagnostic config
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})
		end,
	},
}
