local opt = vim.opt
local g = vim.g

opt.encoding = 'utf8'
opt.mouse = 'a'
opt.wildmenu = true
opt.confirm = true
-- opt.hlsearch = false
opt.incsearch = true
opt.title = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true
opt.cursorline = true
opt.cursorlineopt = 'number'
opt.ignorecase = true
opt.smartcase = true
opt.background = 'dark'
opt.termguicolors = true
opt.splitbelow = true
opt.splitright = true
opt.wrap = true
opt.linebreak = true
opt.scrolloff = 2

g.mapleader = ' '
g.blamer_enabled = true
g.blamer_prefix = '👀 '
g.blamer_show_in_visual_modes = 0
g['test#strategy'] = 'neoterm'

g.neoterm_default_mod = 'botright'
g.neoterm_automap_keys = false

g.UltiSnipsExpandTrigger = '<CR>'
g.UltiSnipsJumpForwardTrigger = '<C-b>'
g.UltiSnipsJumpBackwardTrigger = '<C-z>'

vim.cmd([[ 
  syntax on 
  set nu! rnu! 
  set whichwrap+=<,>,h,l
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
