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
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "neovim/nvim-lspconfig" -- enable LSP
  use "martinsione/darkplus.nvim" -- color scheme
  use "kyazdani42/nvim-web-devicons" -- for file icons
  use "kyazdani42/nvim-tree.lua" -- file tree
  use { 'junegunn/fzf', run = ":call fzf#install()" } -- vim fzf intergrations
  use { 'junegunn/fzf.vim' } -- vim fzf intergrations

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

