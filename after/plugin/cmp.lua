local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "luasnip" }, -- Make sure LuaSnip is included
        { name = "nvim_lsp" },
        { name = "buffer" },
    },
})
