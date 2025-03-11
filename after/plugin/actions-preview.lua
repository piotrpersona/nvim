vim.keymap.set({ "v", "n" }, "<leader>.", require("actions-preview").code_actions)

vim.keymap.set("n", "<leader>i", function()
    vim.lsp.buf.code_action({
        filter = function(action)
            return action.title:match("Fill")
        end,
        apply = true,
    })
end, { silent = true, noremap = true, desc = "Auto Fill Struct/Class" })

require("actions-preview").setup {
  -- options for vim.diff(): https://neovim.io/doc/user/lua.html#vim.diff()
  diff = {
    ctxlen = 3,
  },

  -- priority list of external command to highlight diff
  -- disabled by defalt, must be set by yourself
  highlight_command = {
    -- require("actions-preview.highlight").delta(),
    -- require("actions-preview.highlight").diff_so_fancy(),
    -- require("actions-preview.highlight").diff_highlight(),
  },

  -- priority list of preferred backend
  backend = { "telescope", "nui" },

  -- options related to telescope.nvim
  telescope = {
    sorting_strategy = "ascending",
    layout_strategy = "vertical",
    layout_config = {
      width = 0.4,
      height = 0.6,
      prompt_position = "top",
      preview_cutoff = 20,
      preview_height = function(_, _, max_lines)
        return max_lines - 15
      end,
    },
  },
  -- options for nui.nvim components
  nui = {
    -- component direction. "col" or "row"
    dir = "col",
    -- keymap for selection component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu#keymap
    keymap = nil,
    -- options for nui Layout component: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/layout
    layout = {
      position = "50%",
      size = {
        width = "60%",
        height = "90%",
      },
      min_width = 40,
      min_height = 10,
      relative = "editor",
    },
    -- options for preview area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/popup
    preview = {
      size = "60%",
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
    },
    -- options for selection area: https://github.com/MunifTanjim/nui.nvim/tree/main/lua/nui/menu
    select = {
      size = "40%",
      border = {
        style = "rounded",
        padding = { 0, 1 },
      },
    },
  },
}
