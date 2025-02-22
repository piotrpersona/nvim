-- ThS file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }

  -- Appeareance 
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'nvim-tree/nvim-web-devicons'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use {
    'j-hui/fidget.nvim',
    config = function()
      require("fidget").setup {
        -- options
      }
    end
  }

  -- Themes
  use 'folke/tokyonight.nvim'
  use { "catppuccin/nvim", as = "catppuccin" }
  use "EdenEast/nightfox.nvim"
  use 'Mofiqul/dracula.nvim'
  use "savq/melange-nvim"
  use 'ayu-theme/ayu-vim'
  use 'techtuner/aura-neovim'
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use 'ofirgall/ofirkai.nvim'
  use "rebelot/kanagawa.nvim"
  use 'fedepujol/cosmos.nvim'
  use 'koalhack/koalight.nvim'
  use 'marko-cerovac/material.nvim'

  -- LSP
  use {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    requires = {
      --- Uncomment the two plugins below if you want to manage the language servers from neovim
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      {'neovim/nvim-lspconfig'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  }
  -- Productivity
  use('mbbill/undotree')
  use('tpope/vim-fugitive')
  use('theprimeagen/harpoon')
  use('preservim/nerdcommenter')
  use {
    'nmac427/guess-indent.nvim',
    config = function() require('guess-indent').setup {} end,
  }
  use 'YacineDo/mc.nvim'
  use "lukas-reineke/indent-blankline.nvim"
  use 'stevearc/oil.nvim'

  -- Debugger
  use 'puremourning/vimspector'

  -- Bars/Windows
  use { 'romgrk/barbar.nvim', requires = {
    'lewis6991/gitsigns.nvim',   -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  } }
  use 'prichrd/netrw.nvim'

  -- Git
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  use 'aznhe21/actions-preview.nvim'

  -- Python
  use 'piotrpersona/tele-conda'
end)
