local lsp = require("lsp-zero")
local lspconfig = require("lspconfig")

lsp.preset("recommended")

require("mason").setup()
require('mason-lspconfig').setup({
	ensure_installed = {
		-- Go
		"gopls",
		"gofumpt",
		"golangci_lint_ls",
		"goimports",
		-- Lua
		"lua_ls",
		-- JS
		"tsserver",
		-- Misc
		"rust_analyzer",
		"bashls",
		"clangd",
		-- Python
		"python_lsp_server",
		"black",
		-- API
		"buf",
		-- ZIG
		"zls"
	},
})


lsp.set_preferences({
	suggest_lsp_servers = true,
	sign_icons = {
		error = 'E',
		warn = 'W',
		hint = 'H',
		info = 'I'
	}
})

lspconfig.gopls.setup({
	cmd_env = { GOFLAGS = "-tags=wireinject" },
	settings = {
		gopls = {
			analyses = {
				fillstruct = true
			},
			gofumpt = true,
			goimports = true,
			usePlaceholders = true,
		},
	},
})
lspconfig.pylsp.setup({})
lspconfig.zls.setup({})

local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
    ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
    ['<C-p>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
    ['<C-n>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	-- vim.keymap.set("n", "<leader>.", function() vim.lsp.buf.code_action() end, opts) -- used by action preview
	-- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<leader>ve", function() vim.diagnostic.show_line_diagnostics() end, opts)
	vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
	virtual_text = true
})
