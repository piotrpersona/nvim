vim.api.nvim_create_autocmd(
    "BufWritePost",
    {
        pattern = "*.go",
        command = "silent !gofumpt -w <afile>:p:S",
    }
)
