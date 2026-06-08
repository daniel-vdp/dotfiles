return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local on_attach = function(client, bufnr)
			-- LSP keybindings
			local opts = { buffer = bufnr, silent = true }
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

			-- Enable inlay hints if supported
			if client.server_capabilities.inlayHintProvider then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end

			-- Disable LSP formatting in favour of conform.nvim
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		local util = require("lspconfig.util")

		-- Configure diagnostics
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				source = "if_many",
			},
			float = {
				source = "always",
				border = "rounded",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
		})

		vim.lsp.config.ts_ls = {
			cmd = { "typescript-language-server", "--stdio" },
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			root_markers = { "package.json", "tsconfig.json", ".git" },
			on_attach = on_attach,
			capabilities = capabilities,
			before_init = function(_, config)
				local root = config.root_dir
				if not root then return end
				local sdk = root .. "/.yarn/sdks/typescript/lib"
				if vim.fn.isdirectory(sdk) == 1 then
					config.init_options = vim.tbl_deep_extend("force", config.init_options or {}, {
						tsserver = { path = sdk .. "/tsserver.js" },
					})
				end
			end,
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
				javascript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
		}

		vim.lsp.config.jsonls = {
			cmd = { "vscode-json-language-server", "--stdio" },
			filetypes = { "json", "jsonc" },
			root_markers = { "package.json", ".git" },
			on_attach = on_attach,
			capabilities = capabilities,
		}

		vim.lsp.config.eslint = {
			cmd = { "vscode-eslint-language-server", "--stdio" },
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			root_markers = { "package.json", ".eslintrc.js", ".eslintrc.json", ".git" },
			on_attach = on_attach,
			capabilities = capabilities,
		}

		-- Enable LSP servers
		vim.lsp.enable("ts_ls")
		vim.lsp.enable("jsonls")
		vim.lsp.enable("eslint")
	end,
}
