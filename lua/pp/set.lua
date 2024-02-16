vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ttyfast = true

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.cmd [[colorscheme melange]]
vim.opt.guicursor = 'n-v-c:block-Cursor,i:block-iCursor-blinkwait300-blinkon200-blinkoff150'
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#b55387' })
vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#42363c' })
vim.opt.cursorline = true
-- Cursor
vim.api.nvim_set_hl(0, 'Cursor', { bg = '#b55387' })
vim.api.nvim_set_hl(0, 'iCursor', { fg = '#ffffff', bg = '#4fb2bd' })
-- Popup menu
vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#b08e64' })

