function setColorScheme()
    vim.opt.termguicolors = true

    vim.opt.guicursor = 'n-v-c:block-Cursor,i:block-iCursor-blinkwait300-blinkon200-blinkoff150'
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#b55387' })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#42363c' })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#d9bf41' })
    vim.opt.cursorline = true
    -- Cursor
    vim.api.nvim_set_hl(0, 'Cursor', { bg = '#b55387' })
    vim.api.nvim_set_hl(0, 'iCursor', { fg = '#ffffff', bg = '#4fb2bd' })
    -- Popup menu
    vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#53329c', fg = '#dddddd' })
end
