local opt = vim.opt

opt.encoding = 'utf8'
opt.mouse = 'a'
opt.wildmenu = true
opt.confirm = true
opt.incsearch = true
opt.title = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.cursorline = true
opt.cursorlineopt = 'number'
opt.ignorecase = true
opt.background = 'dark'
opt.termguicolors = true
opt.splitbelow = true
opt.splitright = true
-- opt.t_Co = 256
-- opt.colorcolumn = 100

vim.g.mapleader = " "
vim.g.blamer_enabled = true
vim.g.blamer_prefix = '👀 '
vim.g.blamer_show_in_visual_modes = 0
vim.g['test#strategy'] = "neoterm"

vim.g.neoterm_default_mod = 'botright'
vim.g.neoterm_automap_keys = false

vim.g.UltiSnipsExpandTrigger = '<CR>'
vim.g.UltiSnipsJumpForwardTrigger = '<C-b>'
vim.g.UltiSnipsJumpBackwardTrigger = '<C-z>'

vim.cmd([[ 
  syntax on 
  set nu! rnu! 
  let extension = expand('%:e')
]])

-- Run :PackerCompile after installations
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Highlight on yank
vim.cmd([[
  au TextYankPost * silent! lua vim.highlight.on_yank()
]])
