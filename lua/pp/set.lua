vim.opt.termguicolors = true
vim.cmd.colorscheme("duskfox")

vim.api.nvim_set_hl(0, "LineNr", { fg = "#b55387" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#42363c" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d9bf41" })
vim.api.nvim_set_hl(0, "Cursor", { fg = "#ffffff", bg = "#b55387" })
vim.api.nvim_set_hl(0, "iCursor", { fg = "#ffffff", bg = "#4fb2bd" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#53329c", fg = "#dddddd" })

vim.opt.guicursor = "n-v-c:block-Cursor,i:block-iCursor-blinkwait300-blinkon200-blinkoff150"
vim.opt.cursorline = true

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.winborder = "rounded"

vim.opt.laststatus = 3
vim.opt.statusline = "%!v:lua.require'pp.statusline'.render()"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 50
vim.opt.timeoutlen = 400
vim.opt.isfname:append("@-@")

vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --glob=!.git"
vim.opt.grepformat = "%f:%l:%c:%m"

-- Reload buffers the agent edits on disk; see pp.autocmd for the checktime trigger.
vim.opt.autoread = true

vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
vim.opt.pumheight = 12
