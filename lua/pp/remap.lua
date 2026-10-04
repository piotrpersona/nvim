vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>-", vim.cmd.Oil, { desc = "Open parent directory" })
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undo tree" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("x", "<leader>p", [["_dP]], { desc = "Paste over without clobbering register" })
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank line to clipboard" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without clobbering register" })

map("i", "<C-c>", "<Esc>")
map("n", "Q", "<nop>")
map("n", "gi", "<nop>")

map("n", "<C-f>", "<cmd>silent !tmux new tmux-sessionizer<CR>", { desc = "tmux sessionizer" })

-- Panes
map("n", "<C-h>", "<C-w><C-h>")
map("n", "<C-j>", "<C-w><C-j>")
map("n", "<C-k>", "<C-w><C-k>")
map("n", "<C-l>", "<C-w><C-l>")
map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>_", "<cmd>split<CR>", { desc = "Split horizontal" })

-- Lists
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })
map("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next loclist" })
map("n", "[l", "<cmd>lprev<CR>zz", { desc = "Previous loclist" })
map("n", "<leader>q", function()
    local open = vim.iter(vim.fn.getwininfo()):any(function(w) return w.quickfix == 1 end)
    vim.cmd(open and "cclose" or "copen")
end, { desc = "Toggle quickfix" })

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Substitute word" })
map("n", "<leader>x", "*``cgn", { desc = "Change word, repeat with ." })
map("n", "<leader>X", "#``cgN", { desc = "Change word backwards, repeat with ." })

map("n", "<lt>", "<lt><lt>", { silent = true, desc = "Outdent" })
map("n", ">", ">>", { silent = true, desc = "Indent" })
map("v", "<lt>", "<lt>gv", { silent = true, desc = "Outdent" })
map("v", ">", ">gv", { silent = true, desc = "Indent" })

map("n", ";;", ":w<CR>", { desc = "Write" })
map("n", ";a", ":wa<CR>", { desc = "Write all" })

map("n", "<leader>vpp", "<cmd>e ~/.config/nvim/lua/pp/plugins.lua<CR>", { desc = "Edit plugins" })
map("n", "<leader>vrm", "<cmd>e ~/.config/nvim/lua/pp/remap.lua<CR>", { desc = "Edit remaps" })

-- Harpoon: moved off <C-h>/<C-t>/<C-n>/<C-s>, which collided with panes and completion.
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")
map("n", "<leader>a", mark.add_file, { desc = "Harpoon add file" })
map("n", "<C-e>", ui.toggle_quick_menu, { desc = "Harpoon menu" })
for i = 1, 4 do
    map("n", "<leader>" .. i, function() ui.nav_file(i) end, { desc = "Harpoon file " .. i })
end
