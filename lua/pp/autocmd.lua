-- vim.api.nvim_create_autocmd("BufWritePost", {
--     pattern = "*.go",
--     command = "silent !goimports -local -w <afile>:p:S && gofumpt -w <afile>:p:S",
-- })
-- vim.api.nvim_create_autocmd("BufWritePost", {
--     pattern = "*.py",
--     command = "silent !black <afile>:p:S",
-- })

vim.g.netrw_bufsettings = 'noma nomod nu rnu nobl nowrap ro'
