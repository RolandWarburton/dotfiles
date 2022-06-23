local fn = vim.fn

-- typically this is in ~/.local/share/nvim
-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use {
    "wbthomason/packer.nvim",
    requires = { {'nvim-lua/plenary.nvim'} }
  }-- Have packer manage itself
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "neovim/nvim-lspconfig" -- enable LSP
  use "martinsione/darkplus.nvim" -- color scheme
  use "kyazdani42/nvim-web-devicons" -- for file icons
  use "kyazdani42/nvim-tree.lua" -- file tree
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build --config Release && \
    cmake --install build --prefix build',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use {
    'nvim-treesitter/nvim-treesitter'
  -- to install new TS language support
  -- :TSUpdateSync
  -- :TSInstall typescript
  }
  use {
    'p00f/nvim-ts-rainbow'
  }
  use {'hrsh7th/nvim-cmp'}
  use {'hrsh7th/cmp-buffer'} -- completions from buffers
  use {'hrsh7th/cmp-path'} -- completions for files
  use {'hrsh7th/cmp-nvim-lua'} -- neovim lua completions
  use {'hrsh7th/cmp-nvim-lsp'} -- completions from lsp server
  use {'hrsh7th/cmp-nvim-lsp-signature-help'} -- completions for function signatures
  use {
    'L3MON4D3/LuaSnip',
    config = function()
    require('luasnip').config.set_config {
      history = true,
    }
    require("luasnip.loaders.from_vscode").load {}
    end
  } -- snippets engine for nvim-cmp
  use {'rafamadriz/friendly-snippets'} -- snippets collection for various languages
  use {'windwp/nvim-autopairs'} -- close things like brackets
  use {'tpope/vim-surround'} -- change quotes cs"'
  use {
    'AckslD/nvim-neoclip.lua',
      requires = {
       {'tami5/sqlite.lua', module = 'sqlite'},
       {'nvim-telescope/telescope.nvim'},
    }
  }
  use { 'TimUntersberger/neogit', requires = 'nvim-lua/plenary.nvim' } -- git intergrations
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' } -- git diff for neogit
  use { 'mhinz/vim-signify' } -- git gutter
  use { 'jose-elias-alvarez/null-ls.nvim' }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

