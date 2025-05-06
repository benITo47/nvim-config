return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},

	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local map = vim.keymap.set

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show LSP references"
				map("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				map("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "Smart rename"
				map("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				map("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Show documentation for what is under cursor"
				map("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				map("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		local capabilities = cmp_nvim_lsp.default_capabilities()

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		mason_lspconfig.setup_handlers({
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,

			["lua_ls"] = function()
				lspconfig.lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,

			["eslint"] = function()
				lspconfig.eslint.setup({
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "EslintFixAll",
						})
					end,
					filetypes = { "javascript", "javascriptreact" },
				})
			end,

			["ltex"] = function()
				lspconfig.ltex.setup({
					capabilities = capabilities,
					settings = {
						ltex = {
							language = "en-EN",
						},
					},
					filetypes = { "markdown", "tex", "plaintex" },
				})
			end,

			-- If your server name is `ts_ls` instead of `tsserver`
			["ts_ls"] = function()
				lspconfig.ts_ls.setup({
					capabilities = capabilities,
					filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
					end,
				})
			end,

			["html"] = function()
				lspconfig.html.setup({
					capabilities = capabilities,
					filetypes = { "html", "htmldjango" },
				})
			end,

			["cssls"] = function()
				lspconfig.cssls.setup({
					capabilities = capabilities,
					filetypes = { "css", "scss", "sass", "less" },
				})
			end,

			["rust-analyzer"] = function()
				lspconfig.dockerls.setup({
					capabilities = capabilities,
					filetypes = { "rust" },
				})
			end,
			["dockerls"] = function()
				lspconfig.dockerls.setup({
					capabilities = capabilities,
					filetypes = { "Dockerfile", "dockerfile" },
				})
			end,

			["bashls"] = function()
				lspconfig.bashls.setup({
					capabilities = capabilities,
					filetypes = { "sh", "bash", "zsh" },
				})
			end,

			["clangd"] = function()
				lspconfig.clangd.setup({
					cmd = {
						"clangd",
						"--background-index",
						"-j=12",
						"--query-driver=/opt/homebrew/opt/llvm/bin/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
						"--clang-tidy",
						"--clang-tidy-checks=*",
						"--all-scopes-completion",
						"--cross-file-rename",
						"--completion-style=detailed",
						"--header-insertion-decorators",
						"--header-insertion=iwyu",
						"--pch-storage=memory",
					},
					capabilities = capabilities,
					filetypes = { "c", "cpp", "objc", "objcpp" },
					init_options = {
						clangdFileStatus = true,
						fallbackFlags = { "-std=c++17" },
						clangTidy = true,
						semanticHighlighting = true,
					},
				})
			end,

			["pyright"] = function()
				lspconfig.pyright.setup({
					capabilities = capabilities,
					filetypes = { "python" },
				})
			end,
		})
	end,
}
