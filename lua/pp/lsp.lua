local map = vim.keymap.set

vim.diagnostic.config({
    virtual_text = { current_line = true, prefix = "●" },
    severity_sort = true,
    update_in_insert = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.HINT] = "H",
            [vim.diagnostic.severity.INFO] = "I",
        },
    },
})

local servers = {
    "gopls", "lua_ls", "pylsp", "ruff", "tsgo", "html", "cssls", "bashls", "zls", "clangd", "rust_analyzer",
}

local available = {}
for _, name in ipairs(servers) do
    local cfg = vim.lsp.config[name]
    local cmd = cfg and cfg.cmd
    if type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1 then
        table.insert(available, name)
    end
end
vim.lsp.enable(available)

vim.api.nvim_create_user_command("LspServers", function()
    vim.notify("enabled: " .. table.concat(available, ", "))
end, { desc = "Show which language servers have a binary on PATH" })

local function organize_imports(bufnr)
    local params = vim.lsp.util.make_range_params(0, "utf-16")
    params.context = { only = { "source.organizeImports" }, diagnostics = {} }
    local responses = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 1500) or {}
    for client_id, response in pairs(responses) do
        for _, action in pairs(response.result or {}) do
            if action.edit then
                local client = vim.lsp.get_client_by_id(client_id)
                vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
            end
        end
    end
end

local format_on_save = { go = true, lua = true, zig = true, rust = true, proto = true }

local function prettier(bufnr)
    local root = vim.fs.root(bufnr, "node_modules")
    local bin = root and vim.fs.joinpath(root, "node_modules", ".bin", "prettier")
    return { bin and vim.fn.executable(bin) == 1 and bin or "prettier", "--stdin-filepath", vim.api.nvim_buf_get_name(bufnr) }
end

local formatters = {
    python = function(bufnr) return { "black", "--quiet", "--stdin-filename", vim.api.nvim_buf_get_name(bufnr), "-" } end,
    javascript = prettier,
    javascriptreact = prettier,
    typescript = prettier,
    typescriptreact = prettier,
    html = prettier,
    css = prettier,
}

local function format_with(bufnr, cmd)
    if vim.fn.executable(cmd[1]) == 0 then
        return
    end
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local out = vim.system(cmd, { stdin = lines }):wait(5000)
    if out.code ~= 0 then
        vim.notify(vim.fs.basename(cmd[1]) .. ": " .. vim.trim(out.stderr or ""), vim.log.levels.WARN)
        return
    end
    local formatted = vim.split(out.stdout, "\n")
    table.remove(formatted)
    local hunks = vim.text.diff(table.concat(lines, "\n") .. "\n", out.stdout, { result_type = "indices" })
    for i = #hunks, 1, -1 do
        local old_start, old_count, new_start, new_count = unpack(hunks[i])
        local first = old_count == 0 and old_start or old_start - 1
        vim.api.nvim_buf_set_lines(bufnr, first, first + old_count, false,
            vim.list_slice(formatted, new_start, new_start + new_count - 1))
    end
end

local function format(bufnr)
    local formatter = formatters[vim.bo[bufnr].filetype]
    if formatter then
        format_with(bufnr, formatter(bufnr))
    else
        vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
    end
end

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("pp.format", { clear = true }),
    callback = function(args)
        local formatter = formatters[vim.bo[args.buf].filetype]
        if formatter and not vim.b[args.buf].pp_large_file then
            format_with(args.buf, formatter(args.buf))
        end
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("pp.lsp", { clear = true }),
    callback = function(args)
        local bufnr = args.buf
        if vim.b[bufnr].pp_large_file then
            local client_id = args.data.client_id
            vim.schedule(function()
                if vim.lsp.buf_is_attached(bufnr, client_id) then
                    vim.lsp.buf_detach_client(bufnr, client_id)
                end
            end)
            return
        end

        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
        end

        local opts = function(desc) return { buffer = bufnr, desc = desc } end
        map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
        map("n", "gt", vim.lsp.buf.type_definition, opts("Go to type definition"))
        map("n", "K", vim.lsp.buf.hover, opts("Hover"))
        map("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
        map({ "n", "v" }, "<leader>.", vim.lsp.buf.code_action, opts("Code action"))
        map("n", "<leader>vd", vim.diagnostic.open_float, opts("Line diagnostics"))
        map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts("Next diagnostic"))
        map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts("Previous diagnostic"))
        map("i", "<C-h>", vim.lsp.buf.signature_help, opts("Signature help"))
        map("n", "<leader>F", function() format(bufnr) end, opts("Format buffer"))
        map("n", "<leader>i", function()
            vim.lsp.buf.code_action({
                filter = function(action) return action.title:match("Fill") ~= nil end,
                apply = true,
            })
        end, opts("Fill struct"))

        if format_on_save[vim.bo[bufnr].filetype] and client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    if vim.bo[bufnr].filetype == "go" then
                        organize_imports(bufnr)
                    end
                    vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
                end,
            })
        end
    end,
})

vim.keymap.set("n", "<leader>vl", function()
    vim.cmd.echo('"' .. table.concat(vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 })), ",") .. '"')
end, { desc = "Clients attached to buffer" })

-- Native snippets, no LuaSnip: type the trigger then <C-k>.
local snippets = {
    go = {
        ife = "if err != nil {\n\treturn err\n}\n$0",
        ifr = "if err != nil {\n\treturn ${1}, err\n}\n$0",
        iwf = 'if err != nil {\n\treturn errors.Wrapf(err, "${1}")\n}\n$0',
        iwe = 'if err != nil {\n\treturn errors.Wrap(err, "${1}")\n}\n$0',
    },
}

map("i", "<C-k>", function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.fn.col(".") - 1
    local trigger = line:sub(1, col):match("([%w_]+)$")
    local body = trigger and (snippets[vim.bo.filetype] or {})[trigger]
    if body then
        vim.api.nvim_buf_set_text(0, vim.fn.line(".") - 1, col - #trigger, vim.fn.line(".") - 1, col, { "" })
        vim.snippet.expand(body)
    elseif vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
    end
end, { desc = "Expand snippet or jump forward" })

map({ "i", "s" }, "<C-j>", function()
    if vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
    end
end, { desc = "Jump back in snippet" })

map("i", "<CR>", function()
    return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true, desc = "Accept completion" })

vim.api.nvim_create_user_command("GoTidy", function()
    vim.system({ "go", "mod", "tidy" }, { cwd = vim.fs.root(0, "go.mod") }, function(out)
        vim.schedule(function()
            if out.code == 0 then
                vim.notify("go mod tidy ok")
                vim.cmd.LspRestart()
            else
                vim.notify(out.stderr, vim.log.levels.ERROR)
            end
        end)
    end)
end, { desc = "go mod tidy and restart LSP" })
