local builtin = require('telescope.builtin')
-- grep
vim.keymap.set('n', '<leader>ff', function ()
    builtin.find_files({ hidden = false })
end)
vim.keymap.set('n', '<leader>fh', function ()
    builtin.find_files({ hidden = true })
end)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fs', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
-- git
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>fbr', builtin.git_branches, {})
-- lsp
vim.keymap.set('n', '<leader>gd', function ()
    builtin.lsp_definitions({ jump_type = "vsplit" })
end)
vim.keymap.set('n', '<leader>gt', function()
    builtin.lsp_type_definitions({ jump_type = "vsplit" })
end)
vim.keymap.set('n', '<leader>gi', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>fu', function ()
    builtin.lsp_references({ include_declaration = false })
end)

require("telescope").setup({
  defaults = {
    scroll_strategy = 'limit',
    layout_strategy = 'vertical',
    layout_config = {
      height = 0.95,
      prompt_position = 'bottom',
      width = 0.7,
      preview_cutoff = 0,
      preview_height = 0.6,
    },
    path_display = 'smart',
    dynamic_preview_title = true,
  },
})

