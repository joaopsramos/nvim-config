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
opt.scrolloff = 5
-- Cursor at middle
-- opt.scrolloff = 100
-- opt.ch = 0

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

local function add_lines_to_term()
  local buf_ft = vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), 'filetype')
  if buf_ft == 'neoterm' then
    vim.api.nvim_command('set relativenumber')
    vim.api.nvim_command('set number')
  end
end

local term_group = vim.api.nvim_create_augroup('term_group', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  group = term_group,
  pattern = 'term:/*neoterm*',
  callback = add_lines_to_term
})
