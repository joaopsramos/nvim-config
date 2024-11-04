local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = ' '

if vim.g.vscode then
  require('vscode-config.opts')
  require('vscode-config.remap')
  require('lazy').setup('vscode-plugins')
else
  require('config.opts')
  require('config.remap')
  require('lazy').setup('plugins')
end
