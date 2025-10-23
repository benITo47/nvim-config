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

		-- This LspAttach autocommand is the correct way to set keymaps
		-- and is preserved from your original config.
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
				map("n", "<leader>dD", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				map("n", "<leader>dd", vim.diagnostic.open_float, opts)

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

		mason_lspconfig.setup({
			-- Default handler: updated to new API
			function(server_name)
				vim.lsp.config(server_name, {
					capabilities = capabilities,
				})
				vim.lsp.enable(server_name)
			end,

			-- lua_ls: updated to new API
			["lua_ls"] = function()
				vim.lsp.config("lua_ls", {
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
				vim.lsp.enable("lua_ls")
			end,

			-- eslint: updated to new API
			["eslint"] = function()
				vim.lsp.config("eslint", {
					capabilities = capabilities,
					on_attach = function(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "EslintFixAll",
						})
					end,
					filetypes = { "javascript", "javascriptreact" },
				})
				vim.lsp.enable("eslint")
			end,

			-- ltex: updated to new API
			["ltex"] = function()
				vim.lsp.config("ltex", {
					capabilities = capabilities,
					settings = {
						ltex = {
							language = "en-EN",
						},
					},
					filetypes = { "markdown", "tex", "plaintex" },
				})
				vim.lsp.enable("ltex")
			end,

			-- ts_ls: updated to new API
			["ts_ls"] = function()
				vim.lsp.config("ts_ls", {
					capabilities = capabilities,
					filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
					end,
				})
				vim.lsp.enable("ts_ls")
			end,

			-- html: updated to new API
			["html"] = function()
				vim.lsp.config("html", {
					capabilities = capabilities,
					filetypes = { "html", "htmldjango" },
				})
				vim.lsp.enable("html")
			end,

			-- cssls: updated to new API
			["cssls"] = function()
				vim.lsp.config("cssls", {
					capabilities = capabilities,
					filetypes = { "css", "scss", "sass", "less" },
				})
				vim.lsp.enable("cssls")
			end,

			-- rust_analyzer: updated to new API
			["rust_analyzer"] = function()
				vim.lsp.config("rust_analyzer", {
					capabilities = capabilities,
					filetypes = { "rust" },
				})
				vim.lsp.enable("rust_analyzer")
			end,

			-- dockerls: updated to new API
			["dockerls"] = function()
				vim.lsp.config("dockerls", {
					capabilities = capabilities,
					filetypes = { "Dockerfile", "dockerfile" },
				})
				vim.lsp.enable("dockerls")
			end,

			-- bashls: updated to new API
			["bashls"] = function()
				vim.lsp.config("bashls", {
					capabilities = capabilities,
					filetypes = { "sh", "bash", "zsh" },
				})
				vim.lsp.enable("bashls")
			end,

			-- clangd: updated to new API
			["clangd"] = function()
				vim.lsp.config("clangd", {
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
				vim.lsp.enable("clangd")
			end,

			-- pyright: updated to new API
			["pyright"] = function()
				vim.lsp.config("pyright", {
					capabilities = capabilities,
					filetypes = { "python" },
				})
				vim.lsp.enable("pyright")
			end,
			-- ["sourcekit"] = function()
			-- 	vim.lsp.config("sourcekit", {
			-- 		capabilities = capabilities,
			-- 	})
			-- 	vim.lsp.enable("sourcekit")
			-- end,
			--
		})

		-- Standalone sourcekit setup: updated to new API
		vim.lsp.config("sourcekit", {
			-- capabilities = capabilities,
			capabilities = {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = true,
					},
				},
			},
		})
		vim.lsp.enable("sourcekit")
	end,
}
