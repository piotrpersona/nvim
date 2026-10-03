vim.g.mapleader = " "
vim.keymap.set("n", "<leader>-", vim.cmd.Oil, { desc = "Open parent directory" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>vwm", function()
    require("vim-with-me").StartVimWithMe()
end)
vim.keymap.set("n", "<leader>svwm", function()
    require("vim-with-me").StopVimWithMe()
end)

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "gi", "<nop>")

vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux new tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/pp/packer.lua<CR>");
vim.keymap.set("n", "<leader>rmp", "<cmd>e ~/.config/nvim/lua/pp/remap.lua<CR>");
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- pane split
vim.keymap.set("n", "<leader>vs", "<cmd>:vs<CR>")
vim.keymap.set("n", "<leader>sp", "<cmd>:sp<CR>")

-- pane navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")

-- replace current word under cursor. replace next ocurrence with `.`
vim.keymap.set("n", "<leader>x", "*``cgn")
vim.keymap.set("n", "<leader>X", "#``cgN")

vim.keymap.set("n", ";;", ":w<CR>")
vim.keymap.set("n", ";a", ":wa<CR>")

local function selected_lines()
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
        local line1, line2 = vim.fn.line("v"), vim.fn.line(".")
        if line1 > line2 then
            line1, line2 = line2, line1
        end
        return line1, line2
    end
    return vim.fn.line("."), vim.fn.line(".")
end

-- Copy link to file/line on remote HEAD branch (needs vim-fugitive)
local function copy_remote_link()
    local line1, line2 = selected_lines()
    local remote_head = vim.fn.systemlist("git symbolic-ref refs/remotes/origin/HEAD")[1]
    local branch = remote_head and remote_head:gsub("^refs/remotes/origin/", "") or "HEAD"
    vim.cmd(string.format("%d,%dGBrowse! %s:%%", line1, line2, branch))
end
vim.keymap.set({ "n", "v" }, "<leader>gy", copy_remote_link, { desc = "Copy link to remote HEAD branch" })

-- Copy absolute local filesystem path + line(s) of current file
local function copy_local_path()
    local line1, line2 = selected_lines()
    local path = vim.fn.expand("%:p")
    local link = line1 == line2
        and string.format("%s:%d", path, line1)
        or string.format("%s:%d-%d", path, line1, line2)
    vim.fn.setreg("+", link)
    vim.fn.setreg('"', link)
end
vim.keymap.set({ "n", "v" }, "<leader>gp", copy_local_path, { desc = "Copy local path to file/line" })

-- Indent highlited block
vim.keymap.set("n", "<lt>", "<lt><lt>", { silent = true, desc = "Outdent" })
vim.keymap.set("n", ">", ">>", { silent = true, desc = "Indent" })
vim.keymap.set("v", "<lt>", "<lt>gv", { silent = true, desc = "Indent" })
vim.keymap.set("v", ">", ">gv", { silent = true, desc = "Indent" })
