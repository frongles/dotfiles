-- ===================================
--  LSP & Completion Setup
-- ===================================

-- Mason (LSP installer)
require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = {
		"rust_analyzer",
		"clangd",
		"ts_ls",
		"eslint",
		"postgres_lsp",
		"basedpyright",
		"lua_ls",
		"stylua",
		"bashls",
		"yamlls",
		"wgsl_analyzer",
		"html",
	},
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
	},
})

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}),
})

-- capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
	local bufmap = function(mode, lhs, rhs, desc)
		vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
	end

	bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
	bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
	bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
	bufmap("n", "gr", vim.lsp.buf.references, "List references")
	bufmap("n", "K", vim.lsp.buf.hover, "Hover docs")
	bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
	bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
	bufmap("v", "<leader>ca", vim.lsp.buf.code_action, "Code action")
end

-- LSP server setup (using lspconfig)

vim.lsp.config["rust_analyzer"] = {
	capabilities = capabilities,
	on_attach = on_attach,

	-- https://rust-analyzer.github.io/book/configuration
	settings = {
		["rust-analyzer"] = {
			-- Set the cargo command to clippy instead of check
			checkOnSave = true,
			check = {
				--allTargets = false,
				command = "clippy",
				--features = "all",
				--extraEnv = { },
				workspace = true,
			},
			completion = {
				addSemiColonToUnit = true,
				autoAwait = { enable = true },
				autoIter = { enable = true },
				autoImport = { enable = true },
				autoSelf = { enable = true },
				callable = { snippets = "fill_arguments" },
				fullFunctionSignatures = { enable = true },
				privateEditable = { enable = true },
				termSearch = {
					enable = true,
					fuel = 1000,
				},
			},
			diagnostics = {
				experimental = { enable = true },
				styleLints = { enable = true },
			},
			highlightRelated = {
				branchExitPoints = { enable = true },
				breakPoints = { enable = true },
				closureCaptures = { enable = true },
				exitPoints = { enable = true },
				references = { enable = true },
				yieldPoints = { enable = true },
			},
			lens = {
				debug = { enable = false },
				enable = true,
				references = { adt = { enable = true } },
				enumVariant = { enable = true },
				method = { enable = true },
				run = { enable = false },
			},
		},
	},
}

vim.lsp.config["clangd"] = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config["html"] = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config["yamlls"] = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config["eslint"] = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config["postgres_lsp"] = {
	capabilities = capabilities,
	on_attach = on_attach,
	workspace_required = true,
}

vim.lsp.config["bashls"] = {
	capabilities = capabilities,
	on_attach = on_attach,
}
vim.lsp.config["wgsl_analyzer"] = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config["basedpyright"] = {
	capabilities = capabilities,
	on_attach = on_attach,
	basedpyright = {
		settings = {
			analysis = {
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
			},
		},
	},
}

vim.lsp.config["lua_ls"] = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = { enable = false },
		},
	},
}

vim.diagnostic.config({
	virtual_text = true, -- show inline errors/warnings
	signs = true, -- show in gutter (left side)
	underline = true, -- underline problematic code
	update_in_insert = false,
})

vim.lsp.config["ts_ls"] = {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "typescript", "javascript", "html" },
}

vim.lsp.config["html"] = {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
	},
}
