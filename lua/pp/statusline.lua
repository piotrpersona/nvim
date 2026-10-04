local M = {}

local severity = {
    { vim.diagnostic.severity.ERROR, "E", "DiagnosticError" },
    { vim.diagnostic.severity.WARN,  "W", "DiagnosticWarn" },
    { vim.diagnostic.severity.HINT,  "H", "DiagnosticHint" },
}

local function diagnostics()
    local out = {}
    for _, item in ipairs(severity) do
        local n = #vim.diagnostic.get(0, { severity = item[1] })
        if n > 0 then
            table.insert(out, ("%%#%s#%s%d%%*"):format(item[3], item[2], n))
        end
    end
    return table.concat(out, " ")
end

local function clients()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, client.name)
    end
    return table.concat(names, ",")
end

function M.render()
    local path = vim.fn.expand("%:p")
    local root = vim.b.pp_root
    if root and path:sub(1, #root + 1) == root .. "/" then
        path = path:sub(#root + 2)
    else
        path = vim.fn.expand("%:~:.")
    end
    return table.concat({
        " ", path == "" and "[No Name]" or path, "%h%m%r",
        "%=", diagnostics(), "  ", clients(),
        "  %l:%c %P ",
    })
end

return M
