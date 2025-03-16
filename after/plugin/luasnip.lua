local ls = require("luasnip")
local snippet = ls.snippet
local text = ls.text_node
local insert = ls.insert_node

ls.add_snippets("go", {
    snippet("iwf", {
        text({ "if err != nil {", "\treturn errors.Wrapf(err, \"" }),
        insert(1, ''), -- Cursor inside the function
        text({ "\")", "}" }),
    }),
    snippet("iwe", {
        text({ "if err != nil {", "\treturn errors.Wrap(err, \"" }),
        insert(1, ''), -- Cursor inside the function
        text({ "\")", "}" }),
    }),
})


vim.api.nvim_set_keymap("i", "<C-k>", "<cmd>lua require'luasnip'.expand_or_jump()<CR>", { silent = true, noremap = true })

