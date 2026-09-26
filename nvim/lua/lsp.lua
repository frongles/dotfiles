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
		"bashls",
		"yamlls",
		"wgsl_analyzer",
		"html",
		"kotlin_lsp",
		"ansiblels",
		"terraformls",
		"tombi",
		"fish_lsp",
		"lemminx",
		"docker_compose_language_service",
	},

	automatic_enable = {
		exclude = { "kotlin_lsp" },
	},
})

require("mason-tool-installer").setup({
	ensure_installed = {
		"stylua",
		"prettierd",
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

local lsp_keymaps = vim.api.nvim_create_augroup("user-lsp-keymaps", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_keymaps,

	callback = function(event)
		local bufnr = event.buf

		local bufmap = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, {
				buffer = bufnr,
				desc = desc,
			})
		end

		bufmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
		bufmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
		bufmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
		bufmap("n", "<leader>lr", vim.lsp.buf.references, "List references")
		bufmap("n", "K", vim.lsp.buf.hover, "Hover documentation")
		bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		bufmap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		if client:supports_method("textDocument/linkedEditingRange") then
			vim.lsp.linked_editing_range.enable(true, {
				client_id = client.id,
				bufnr = bufnr,
			})
		end

		if client:supports_method("textDocument/onTypeFormatting") then
			vim.lsp.on_type_formatting.enable(true, {
				client_id = client.id,
			})
		end
	end,
})

-- LSP server setup

vim.lsp.config("*", {
	capabilities = capabilities,
})

vim.lsp.config["rust_analyzer"] = {

	-- https://rust-analyzer.github.io/book/configuration
	settings = {
		["rust-analyzer"] = {
			-- Set the cargo command to clippy instead of check
			checkOnSave = true,
			cargo = {
				targetDir = true,
			},
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

vim.lsp.config["postgres_lsp"] = {
	workspace_required = true,
}

vim.lsp.config["basedpyright"] = {
	settings = {
		basedpyright = {
			analysis = {
				diagnosticMode = "openFilesOnly",
				useLibraryCodeForTypes = true,
			},
		},
	},
}

vim.lsp.config["lua_ls"] = {
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
	virtual_text = false,
	virtual_lines = { current_line = true },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

vim.lsp.config["ts_ls"] = {
	filetypes = { "typescript", "typescriptreact", "javascriptreact", "javascript", "html" },
}

vim.lsp.config["html"] = {
	filetypes = { "html" },
	init_options = {
		configurationSection = { "html", "css", "javascript" },
		embeddedLanguages = {
			css = true,
			javascript = true,
		},
	},
}
