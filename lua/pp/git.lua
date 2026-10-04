local map = vim.keymap.set

require("gitsigns").setup({
    on_attach = function(bufnr)
        local gs = require("gitsigns")
        local opts = function(desc) return { buffer = bufnr, desc = desc } end

        map("n", "]h", function() gs.nav_hunk("next") end, opts("Next hunk"))
        map("n", "[h", function() gs.nav_hunk("prev") end, opts("Previous hunk"))
        map("n", "<leader>hp", gs.preview_hunk, opts("Preview hunk"))
        map("n", "<leader>hs", gs.stage_hunk, opts("Stage hunk"))
        map("n", "<leader>hr", gs.reset_hunk, opts("Reset hunk"))
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts("Blame line"))
        map("n", "<leader>hd", gs.diffthis, opts("Diff this file"))
    end,
})

map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "Diff working tree" })
map("n", "<leader>gD", "<cmd>DiffviewOpen origin/main<CR>", { desc = "Diff against origin/main" })
map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Close diffview" })
map("n", "<leader>gl", "<cmd>DiffviewFileHistory %<CR>", { desc = "File history" })

local function git(args)
    local out = vim.system(vim.list_extend({ "git" }, args), { cwd = vim.fn.expand("%:p:h") }):wait()
    if out.code ~= 0 then
        return nil
    end
    return vim.trim(out.stdout)
end

local function selected_lines()
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
        local a, b = vim.fn.line("v"), vim.fn.line(".")
        if a > b then
            a, b = b, a
        end
        return a, b
    end
    local line = vim.fn.line(".")
    return line, line
end

local function copy(text)
    vim.fn.setreg("+", text)
    vim.fn.setreg('"', text)
    vim.notify(text)
end

local function suffix(line1, line2, sep)
    if line1 == line2 then
        return ("%s%d"):format(sep, line1)
    end
    return ("%s%d%s%d"):format(sep, line1, sep == "#L" and "-L" or "-", line2)
end

-- <leader>gp: what an agent can resolve - path relative to the repo root.
local function copy_relative_path()
    local line1, line2 = selected_lines()
    local path = vim.fn.expand("%:p")
    local root = vim.b.pp_root
    if root and path:sub(1, #root + 1) == root .. "/" then
        path = path:sub(#root + 2)
    end
    copy(path .. suffix(line1, line2, ":"))
end

local function copy_absolute_path()
    local line1, line2 = selected_lines()
    copy(vim.fn.expand("%:p") .. suffix(line1, line2, ":"))
end

local function remote_web_url()
    local url = git({ "remote", "get-url", "origin" })
    if not url then
        return nil
    end
    url = url:gsub("%.git$", "")
    local host, path = url:match("^git@([^:]+):(.+)$")
    if host then
        return ("https://%s/%s"):format(host, path)
    end
    return (url:gsub("^ssh://git@", "https://"))
end

local function copy_remote_link()
    local line1, line2 = selected_lines()
    local base = remote_web_url()
    if not base then
        vim.notify("no origin remote", vim.log.levels.ERROR)
        return
    end
    local ref = git({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })
    ref = ref and ref:gsub("^origin/", "") or git({ "rev-parse", "HEAD" })
    local path = git({ "ls-files", "--full-name", vim.fn.expand("%:p") })
    if not path or path == "" then
        vim.notify("file is not tracked by git", vim.log.levels.ERROR)
        return
    end
    local blob = base:find("gitlab") and "/-/blob/" or "/blob/"
    copy(base .. blob .. ref .. "/" .. path .. suffix(line1, line2, "#L"))
end

-- <leader>gm: the block you paste into a prompt - location plus the code.
local function copy_markdown_block()
    local line1, line2 = selected_lines()
    local path = vim.fn.expand("%:p")
    local root = vim.b.pp_root
    if root and path:sub(1, #root + 1) == root .. "/" then
        path = path:sub(#root + 2)
    end
    local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
    copy(table.concat({
        path .. suffix(line1, line2, ":"),
        "```" .. (vim.bo.filetype ~= "" and vim.bo.filetype or ""),
        table.concat(lines, "\n"),
        "```",
    }, "\n"))
end

map({ "n", "v" }, "<leader>gp", copy_relative_path, { desc = "Copy repo-relative path:line" })
map({ "n", "v" }, "<leader>gP", copy_absolute_path, { desc = "Copy absolute path:line" })
map({ "n", "v" }, "<leader>gy", copy_remote_link, { desc = "Copy remote permalink" })
map({ "n", "v" }, "<leader>gm", copy_markdown_block, { desc = "Copy selection as fenced block" })
