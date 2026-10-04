vim.pack.add({
    "https://github.com/EdenEast/nightfox.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    "https://github.com/ibhagwan/fzf-lua",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/theprimeagen/harpoon",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/sindrets/diffview.nvim",
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/mbbill/undotree",
    "https://github.com/nmac427/guess-indent.nvim",
})

require("guess-indent").setup({})

require("oil").setup({
    default_file_explorer = true,
    columns = { "icon" },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = { show_hidden = true },
})

local parsers = {
    "bash", "dockerfile", "go", "gomod", "gosum", "gotmpl", "gowork",
    "javascript", "json", "proto", "python", "sql", "terraform",
    "toml", "tsx", "typescript", "yaml",
}

local ts = require("nvim-treesitter")
ts.setup({})

vim.api.nvim_create_user_command("TSInstallAll", function()
    ts.install(parsers, { summary = true })
end, { desc = "Install/update treesitter parsers" })

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("pp.treesitter", { clear = true }),
    callback = function(args)
        if vim.b[args.buf].pp_large_file then
            return
        end
        if not vim.treesitter.language.get_lang(args.match) then
            return
        end
        pcall(vim.treesitter.start, args.buf)
    end,
})
