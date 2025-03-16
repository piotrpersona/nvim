local ls = require("luasnip")
local snippet = ls.snippet
local text = ls.text_node
local insert = ls.insert_node

ls.add_snippets("go", {
    -- if err != nil {
    --     return err
    -- }
    snippet("ife", {
        text({ "if err != nil {", "\treturn err", "}" }),
    }),
    -- if err != nil {
    --     return <i>
    -- }
    snippet("ifr", {
        text({ "if err != nil {", "\treturn " }),
        insert(1, ''),
        text({ "", "}" }),
    }),
    -- if err != nil {
    --     return errors.Wrapf(err, "<i>")
    -- }
    snippet("iwf", {
        text({ "if err != nil {", "\treturn errors.Wrapf(err, \"" }),
        insert(1, ''),
        text({ "\")", "}" }),
    }),
    -- if err != nil {
    --     return errors.Wrap(err, "<i>")
    -- }
    snippet("iwe", {
        text({ "if err != nil {", "\treturn errors.Wrap(err, \"" }),
        insert(1, ''),
        text({ "\")", "}" }),
    }),
})


vim.api.nvim_set_keymap("i", "<C-k>", "<cmd>lua require'luasnip'.expand_or_jump()<CR>", { silent = true, noremap = true })

