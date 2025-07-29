function setColorScheme(isDayTime)
    vim.opt.termguicolors = true

    local palettes = {
        day = {
            line_nr = "#3118ad",
            cursor_line_bg = "#f5a9cf",
            cursor_line_nr = "#b3005c"
        },
        night = {
            line_nr = "#b55387",
            cursor_line_bg = "#42363c",
            cursor_line_nr = "#d9bf41"
        }
    }

    local palette = isDayTime and palettes.day or palettes.night
    
    if isDayTime then
        vim.api.nvim_set_hl(0, "Normal", { fg = "#0b0b0d" })
    end

    vim.opt.guicursor = 'n-v-c:block-Cursor,i:block-iCursor-blinkwait300-blinkon200-blinkoff150'

    vim.api.nvim_set_hl(0, 'LineNr', { fg = palette.line_nr })
    vim.api.nvim_set_hl(0, 'CursorLine', { bg = palette.cursor_line_bg })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = palette.cursor_line_nr })
    vim.opt.cursorline = true
    -- Cursor
    vim.api.nvim_set_hl(0, 'Cursor', { fg = '#ffffff', bg = '#b55387' })
    vim.api.nvim_set_hl(0, 'iCursor', { fg = '#ffffff', bg = '#4fb2bd' })
    -- Popup menu
    vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#53329c', fg = '#dddddd' })
end
