-- ===================================
--  Vim Plugins
-- ===================================

-- ===================================
--  Plugin Manager (lazy.nvim)
-- ===================================
-- Auto-install lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ===================================
--  Plugins
-- ===================================
require("lazy").setup({
	{
		"miikanissi/modus-themes.nvim",
		priority = 1000,
		config = function()
			require("modus-themes").setup({
				style = "auto",
				variants = "tinted",
				transparent = false,
				dim_inactive = true,
				line_nr_column_background = true,
				sign_column_background = true,
				-- Value is any valid attr-list value for `:help nvim_set_hl`
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
				},
			})

			vim.cmd.colorscheme("modus")
		end,
	},
	-- UI
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				--options = { theme = "gruvbox" },
			})
		end,
	},

	-- File explorer
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("nvim-tree").setup({})
		end,
	},

	-- pane navigation
	{
		"christoomey/vim-tmux-navigator",
		init = function()
			vim.g.tmux_navigator_no_mappings = 1
		end,
	},
	--[[ Markdown
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
        opts = {},
    }, --]]

	-- Surround
	{
		"kylechui/nvim-surround",
		version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},

	-- Git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 300,
				ignore_whitespace = false,
			},

			preview_config = {
				border = "single",
			},

			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- match your style: <leader> prefix
				map("n", "<leader>gp", gs.preview_hunk, "Git preview hunk")
				map("n", "<leader>gb", gs.toggle_current_line_blame, "Git toggle line blame")
				map("n", "<leader>gd", gs.toggle_deleted, "Git toggle deleted (inline old lines)")
				map("n", "<leader>gs", gs.stage_hunk, "Git stage hunk")
				map("n", "<leader>gr", gs.reset_hunk, "Git reset hunk")

				-- navigation (like Xcode next/prev change)
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, "Next git hunk")
				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, "Prev git hunk")
			end,
		},
	},

	{
		-- tree sitter
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				ensure_installed = {
					"sql",
					"bash",
					"lua",
					"python",
					"javascript",
					"rust",
					"typescript",
					"markdown",
					"toml",
					"wgsl",
				},
				sync_install = false,
				auto_install = true,
				ignore_install = {},
				modules = {},
				highlight = {
					enable = true,
				},
				indent = {
					enable = true,
				},
			})
			require("nvim-treesitter").install({
				"sql",
				"bash",
				"lua",
				"python",
				"javascript",
				"rust",
				"typescript",
				"markdown",
				"toml",
				"wgsl",
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 3, -- how many context lines to show
				trim_scope = "outer", -- drop inner contexts first
				mode = "cursor", -- follow cursor (recommended)
				separator = "─",
			})
		end,
	},

	-- Telescope + deps
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					sorting_strategy = "ascending",
					layout_config = { prompt_position = "top" },
				},
			})

			-- load native sorter (if installed)
			pcall(telescope.load_extension, "fzf")
		end,
	},

	-- Native sorter for speed (requires make)
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	-- formatting engine
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					rust = { "rustfmt" },
				},
			})
		end,
	},

	-- mason tool installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},

	-- ===================================
	-- LSP & Completion
	-- ===================================
	{ "neovim/nvim-lspconfig" }, -- LSP configs
	{ "williamboman/mason.nvim" }, -- LSP installer
	{ "williamboman/mason-lspconfig.nvim" }, -- bridge Mason + lspconfig
	{ "hrsh7th/nvim-cmp" }, -- completion engine
	{ "hrsh7th/cmp-nvim-lsp" }, -- LSP source for cmp
	{ "L3MON4D3/LuaSnip" }, -- snippet engine
	{ "saadparwaiz1/cmp_luasnip" }, -- snippet completions
})
