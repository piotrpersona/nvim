return {
    cmd = { "pylsp" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "uv.lock", "setup.py", ".git" },
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
            },
        },
    },
}
