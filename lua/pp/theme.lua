function setColorScheme()
    vim.opt.guicursor = 'n-v-c:block-Cursor,i:block-iCursor-blinkwait300-blinkon200-blinkoff150'
    vim.api.nvim_set_hl(0, 'LineNr', { fg = '#b55387' })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#42363c' })
    vim.opt.cursorline = true
    -- Cursor
    vim.api.nvim_set_hl(0, 'Cursor', { bg = '#b55387' })
    vim.api.nvim_set_hl(0, 'iCursor', { fg = '#ffffff', bg = '#4fb2bd' })
    -- Popup menu
    vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#b08e64' })
end
