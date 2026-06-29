-- ===================================
--  Neovim Options
-- ===================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.termguicolors = true
vim.opt.cursorline = true

-- Open Telescope file picker on startup if no file was provided
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			require("telescope.builtin").find_files()
		end
	end,
})

-- Replace :e with a Telescope file picker (supports :e foo to prefill)
vim.api.nvim_create_user_command("E", function(opts)
	require("telescope.builtin").find_files({ default_text = opts.args })
end, { nargs = "*" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufname = vim.api.nvim_buf_get_name(args.buf)
		if bufname:match("%.html$") or bufname:match("%.marko$") then
			return
		end
		if not client or not client:supports_method("textDocument/documentHighlight") then
			return
		end

		local group = vim.api.nvim_create_augroup("lsp-document-highlight", { clear = false })

		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = group,
			buffer = args.buf,
			callback = vim.lsp.buf.document_highlight,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = group,
			buffer = args.buf,
			callback = vim.lsp.buf.clear_references,
		})
	end,
})

vim.o.updatetime = 300

vim.api.nvim_create_user_command("InlayHintsToggle", function()
	local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
end, {})

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--   callback = function()
--     vim.lsp.codelens.refresh()
--   end,
-- })

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		require("conform").format({ async = false })
	end,
})

vim.filetype.add({
	extension = {
		service = "ini",
		timer = "ini",
		socket = "ini",
		target = "ini",
		mount = "ini",
		automount = "ini",
		path = "ini",
		slice = "ini",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function(ev)
		pcall(vim.treesitter.start, ev.buf)
	end,
})

-- ===================================
--  Java/Typescript indentation
-- ===================================
---vim.api.nvim_create_autocmd("FileType", {
---  pattern = { "typescriptreact", "typescript", "javascriptreact", "javascript" },
---  callback = function()
---    vim.bo.tabstop = 4
---    vim.bo.shiftwidth = 4
---    vim.bo.expandtab = true
---  end,
---})
