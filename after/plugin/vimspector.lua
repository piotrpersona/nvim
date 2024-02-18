vim.keymap.set('n', '<leader>di', function()
    vim.cmd("VimspectorBalloonEval")
end)
vim.keymap.set('i', '<leader>di', function()
    vim.cmd("VimspectorBalloonEval")
end)

-- source:
-- https://dev.to/iggredible/debugging-in-vim-with-vimspector-4n0m
vim.keymap.set('n', '<leader>dd', '<cmd>call vimspector#Launch()<CR>')
vim.keymap.set('n', '<leader>de', '<cmd>call vimspector#Reset()<CR>')
vim.keymap.set('n', '<leader>dc', '<cmd>call vimspector#Continue()<CR>')

vim.keymap.set('n', '<leader>dt', '<cmd>call vimspector#ToggleBreakpoint()<CR>')
vim.keymap.set('n', '<leader>dT', '<cmd>call vimspector#ClearBreakpoints()<CR>')

vim.keymap.set('n', '<leader>dk', '<cmd>VimspectorReset<CR>')
vim.keymap.set('n', '<leader>dh', '<cmd>VimspectorStepOut<CR>')
vim.keymap.set('n', '<leader>dl', '<cmd>VimspectorStepInto<CR>')
vim.keymap.set('n', '<leader>dj', '<cmd>VimspectorStepOver<CR>')
