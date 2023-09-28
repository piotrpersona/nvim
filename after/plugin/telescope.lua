local builtin = require('telescope.builtin')
local action_state = require('telescope.actions.state')
-- grep
vim.keymap.set('n', '<leader>ff', function()
    builtin.find_files({ hidden = false })
end)
vim.keymap.set('n', '<leader>fh', function()
    builtin.find_files({ hidden = true })
end)
vim.keymap.set('n', '<leader><leader>', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fs', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)
-- git
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>gbr', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
-- lsp
vim.keymap.set('n', '<leader>gd', function()
    builtin.lsp_definitions({ jump_type = "vsplit" })
end)
vim.keymap.set('n', '<leader>gt', function()
    builtin.lsp_type_definitions({ jump_type = "vsplit" })
end)
vim.keymap.set('n', '<leader>gi', builtin.lsp_implementations, {})
vim.keymap.set('n', '<leader>fu', function()
    builtin.lsp_references({ include_declaration = false })
end)
-- colorscheme
vim.keymap.set('n', '<leader>th', function ()
    builtin.colorscheme({ enable_preview = true })
end)

-- diffview
vim.keymap.set('n', '<leader>dm', function()
    vim.cmd("DiffviewOpen origin/main")
end)
vim.keymap.set('n', '<leader>dvc', function()
    vim.cmd("DiffviewClose")
end)
vim.keymap.set('n', '<leader>dvo', function()
    vim.cmd("DiffviewClose")
end)

function TelescopeDiffviewOpen()
    -- Open in diffview
    local selected_entry = action_state.get_selected_entry()
    local value = selected_entry.value
    -- close Telescope window properly prior to switching windows
    vim.api.nvim_win_close(0, true)
    vim.cmd("stopinsert")
    vim.schedule(function()
        vim.cmd(("DiffviewOpen %s"):format(value))
    end)
end

require("telescope").setup({
    defaults = {
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '-uu' -- **This is the added flag**
        },
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
    pickers = {
        git_commits = {
            mappings = {
                i = {
                    ["<leader>d"] = TelescopeDiffviewOpen,
                }
            },
        },
        git_branches = {
            mappings = {
                i = {
                    ["<leader>d"] = TelescopeDiffviewOpen,
                }
            }
        }
    }
})
