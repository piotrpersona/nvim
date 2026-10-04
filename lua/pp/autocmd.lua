local augroup = vim.api.nvim_create_augroup("pp", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

local max_file_size = 256 * 1024

autocmd("BufReadPre", {
    group = augroup,
    callback = function(args)
        local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
        if stat and stat.size > max_file_size then
            vim.b[args.buf].pp_large_file = true
            vim.bo[args.buf].undofile = false
        end
    end,
})

-- Filetype detection re-enables syntax after BufReadPre, so strip it here. The
-- treesitter and LSP handlers key off pp_large_file themselves.
autocmd("FileType", {
    group = augroup,
    callback = function(args)
        if not vim.b[args.buf].pp_large_file then
            return
        end
        -- Deferred: nvim's own syntaxset handler also fires on FileType.
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
                vim.bo[args.buf].syntax = ""
            end
        end)
    end,
})

autocmd({ "BufReadPost", "BufNewFile", "BufFilePost" }, {
    group = augroup,
    callback = function(args)
        vim.b[args.buf].pp_root = vim.fs.root(args.buf, ".git")
    end,
})

-- An agent edits files under us: pull changes in instead of going stale.
autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
    group = augroup,
    callback = function()
        if vim.fn.mode() == "c" or vim.fn.getcmdwintype() ~= "" then
            return
        end
        if vim.bo.buftype ~= "" then
            return
        end
        pcall(vim.cmd.checktime)
    end,
})

autocmd("FileChangedShellPost", {
    group = augroup,
    callback = function(args)
        vim.notify(
            ("reloaded %s from disk"):format(vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":t")),
            vim.log.levels.WARN
        )
    end,
})

autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.hl.on_yank({ timeout = 120 })
    end,
})

vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
