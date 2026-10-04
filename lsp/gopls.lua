-- The asdf `gopls` shim refuses to run in a directory with no resolvable golang
-- version ("No version is set for command gopls"), so prefer the real binary in
-- GOBIN. asdf shims stay on PATH so gopls can still find `go` itself.
local function cmd()
    local candidates = {
        vim.env.GOBIN and vim.env.GOBIN .. "/gopls",
        vim.env.GOPATH and vim.env.GOPATH .. "/bin/gopls",
        vim.env.HOME .. "/go/bin/gopls",
    }
    for _, candidate in ipairs(vim.tbl_filter(function(c) return c ~= nil end, candidates)) do
        if vim.fn.executable(candidate) == 1 then
            return { candidate }
        end
    end
    return { "gopls" }
end

return {
    cmd = cmd(),
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod", ".git" },
    cmd_env = {
        GOFLAGS = "-tags=wireinject",
        PATH = (vim.env.ASDF_DATA_DIR or (vim.env.HOME .. "/.asdf")) .. "/shims:" .. vim.env.PATH,
    },
    settings = {
        gopls = {
            gofumpt = true,
            usePlaceholders = true,
            semanticTokens = false,
            directoryFilters = { "-vendor", "-node_modules", "-.git" },
            analyses = { fillstruct = true, unusedparams = true, nilness = true },
            staticcheck = true,
        },
    },
}
