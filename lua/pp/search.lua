local fzf = require("fzf-lua")
local map = vim.keymap.set

local rg_files = "rg --files --no-messages --glob=!.git"

local function diffview(selected)
    local rev = selected[1]:match("^%x%x%x%x%x+") or selected[1]:match("^%S+")
    if not rev then
        return
    end
    vim.schedule(function()
        vim.cmd(("DiffviewOpen %s"):format(rev))
    end)
end

fzf.setup({
    winopts = {
        height = 0.95,
        width = 0.8,
        preview = { layout = "vertical", vertical = "up:60%", scrollbar = false },
    },
    files = { cmd = rg_files, formatter = "path.filename_first" },
    grep = {
        rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 --glob=!.git",
    },
    git = {
        commits = { actions = { ["ctrl-d"] = diffview } },
        branches = { actions = { ["ctrl-d"] = diffview } },
    },
})

map("n", "<leader><leader>", fzf.live_grep_native, { desc = "Live grep" })
map("n", "<leader>ff", function() fzf.files({ cmd = rg_files }) end, { desc = "Find files" })
map("n", "<leader>fh", function() fzf.files({ cmd = rg_files .. " --hidden" }) end, { desc = "Find files (hidden)" })
map("n", "<leader>fs", fzf.grep, { desc = "Grep prompt" })
map({ "n", "v" }, "<leader>fc", fzf.grep_cword, { desc = "Grep word under cursor" })
map("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
map("n", "<leader>fo", fzf.oldfiles, { desc = "Recent files" })
map("n", "<leader>f/", fzf.blines, { desc = "Lines in buffer" })
map("n", "<leader>fr", fzf.resume, { desc = "Resume last picker" })
map("n", "<leader>fu", function() fzf.lsp_references({ includeDeclaration = false }) end, { desc = "LSP references" })
map("n", "<leader>fw", fzf.lsp_live_workspace_symbols, { desc = "Workspace symbols" })
map("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
map("n", "<leader>gi", fzf.lsp_implementations, { desc = "LSP implementations" })
map("n", "<leader>gf", fzf.git_files, { desc = "Git files" })
map("n", "<leader>gbr", fzf.git_branches, { desc = "Git branches (ctrl-d: diffview)" })
map("n", "<leader>gc", fzf.git_commits, { desc = "Git commits (ctrl-d: diffview)" })
map("n", "<leader>th", fzf.colorschemes, { desc = "Colorschemes" })
