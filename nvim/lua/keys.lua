vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- basic
local keymap = vim.keymap.set
keymap("n", "<leader>w", ":w<CR>")
keymap("n", "<leader>q", ":q<CR>")
keymap("n", "<leader>h", ":nohlsearch<CR>")

-- Buffer navigation
keymap("n", "<leader>n", "<cmd>bn<CR>", { desc = "Next buffer" })
keymap("n", "<leader>p", "<cmd>bp<CR>", { desc = "Previous buffer" })
keymap("n", "<leader>bd", "<cmd>bnext | bdelete #<CR>", { desc = "Delete buffer (keep window)" })
keymap("n", "<leader>v", "<cmd>vsplit<CR>", { desc = "Split window vertically" })
keymap("n", "<leader>s", "<cmd>split<CR>", { desc = "Split window horizontally" })

keymap("n", "<leader>th", function()
	vim.treesitter.stop()
	vim.treesitter.start()
end, { desc = "Reset Treesitter highlighting" })

vim.keymap.set("n", "<leader>/", function()
	require("telescope.builtin").current_buffer_fuzzy_find()
end)

-- nvim tree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Diagnostics navigation (errors/warnings)
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<leader>do", vim.diagnostic.open_float, { desc = "Line diagnostics" })
keymap("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Tmux navigator - use Meta (Alt) + hjkl instead of Ctrl
local opts = { silent = true }

vim.keymap.set("n", "<M-h>", "<cmd>TmuxNavigateLeft<CR>", opts)
vim.keymap.set("n", "<M-j>", "<cmd>TmuxNavigateDown<CR>", opts)
vim.keymap.set("n", "<M-k>", "<cmd>TmuxNavigateUp<CR>", opts)
vim.keymap.set("n", "<M-l>", "<cmd>TmuxNavigateRight<CR>", opts)
vim.keymap.set("n", "<M-\\>", "<cmd>TmuxNavigatePrevious<CR>", opts)
