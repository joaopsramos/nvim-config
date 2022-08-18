vim.cmd([[ set encoding=utf8 ]])
vim.cmd([[ set nu! rnu! ]])
vim.cmd([[ set mouse=a ]])
vim.cmd([[ set wildmenu ]])
vim.cmd([[ set confirm ]])
vim.cmd([[ set incsearch ]])
vim.cmd([[ set title ]])
vim.cmd([[ set t_Co=256 ]])
vim.cmd([[ set shiftwidth=2 ]])
vim.cmd([[ set softtabstop=2 ]])
vim.cmd([[ set expandtab ]])
vim.cmd([[ set shiftwidth=2 ]])
vim.cmd([[ set softtabstop=2 ]])
vim.cmd([[ set colorcolumn=100 ]])
vim.cmd([[ set expandtab ]])
vim.cmd([[ 
  highlight Cursor guifg=white guibg=black
  highlight iCursor guifg=white guibg=steelblue
  set guicursor=n-v-c:block-Cursor
  set guicursor+=i:ver100-iCursor
  set guicursor+=n-v-c:blinkon0
  set guicursor+=i:blinkwait10
]])
vim.cmd([[ set cursorline ]])
vim.cmd([[ syntax on ]])
vim.cmd([[ set ignorecase ]])

vim.cmd([[ let extension = expand('%:e') ]])
vim.cmd([[ let mapleader = " " ]])
vim.cmd[[ set background=dark ]]
vim.cmd[[ set termguicolors ]]
vim.cmd([[ 
  set splitbelow
  set splitright
]])

-- Run :PackerCompile after installations
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

vim.g['neoterm_default_mod'] = 'botright'
vim.cmd([[ let test#strategy = "neoterm"]])
vim.g.neoterm_automap_keys = false

vim.cmd([[ let g:blamer_enabled = 1 ]])

vim.g['UltiSnipsExpandTrigger'] = '<CR>'
vim.g['UltiSnipsJumpForwardTrigger'] = '<c-b>'
vim.g['UltiSnipsJumpBackwardTrigger'] = '<c-z>'

