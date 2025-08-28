local opt = vim.opt

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
-- opt.colorcolumn = 100
-- Cursor at middle
-- opt.scrolloff = 100
-- opt.ch = 0

if os.getenv("XDG_CURRENT_DESKTOP") == "Hyprland" then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy",
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste",
    },
    cache_enabled = 0,
  }
end

if vim.g.neovide then
  opt.linespace = 0
  vim.o.guifont = "Hack Nerd Font Mono:h11"
  -- vim.g.neovide_scale_factor = 0.84
  vim.g.neovide_text_gamma = 0.0
  vim.g.neovide_text_contrast = 0.5
  vim.g.neovide_fullscreen = false
  vim.g.neovide_cursor_vfx_mode = ""
  vim.g.neovide_cursor_vfx_particle_density = 10.0
  vim.g.neovide_floating_shadow = false

  vim.g.terminal_color_0 = "#21222c"
  vim.g.terminal_color_8 = "#6272a4"
  vim.g.terminal_color_1 = "#ff5555"
  vim.g.terminal_color_9 = "#ff6e6e"
  vim.g.terminal_color_2 = "#50fa7b"
  vim.g.terminal_color_10 = "#69ff94"
  vim.g.terminal_color_3 = "#f1fa8c"
  vim.g.terminal_color_11 = "#ffffa5"
  vim.g.terminal_color_4 = "#bd93f9"
  vim.g.terminal_color_12 = "#d6acff"
  vim.g.terminal_color_5 = "#ff79c6"
  vim.g.terminal_color_13 = "#ff92df"
  vim.g.terminal_color_6 = "#8be9fd"
  vim.g.terminal_color_14 = "#a4ffff"
  vim.g.terminal_color_7 = "#f8f8f2"
  vim.g.terminal_color_15 = "#ffffff"

  -- vim.g.neovide_cursor_vfx_particle_lifetime = 2

  -- Helper function for transparency formatting
  -- local alpha = function()
  --   return string.format("%x", math.floor((255 * vim.g.transparency) or 0.8))
  -- end
  -- -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  -- vim.g.neovide_transparency = 0.0
  -- vim.g.transparency = 0.8
  -- vim.g.neovide_background_color = "#0f1117" .. alpha()
  -- vim.g.neovide_window_blurred = true
end

-- nvim-ufo
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

vim.cmd([[
  syntax on
  set nu! rnu!
  set whichwrap+=<,>,h,l
  let extension = expand('%:e')
]])

-- Highlight on yank
vim.cmd([[
  au TextYankPost * silent! lua vim.highlight.on_yank()
]])

-- Go indentation
vim.cmd([[
  au FileType go set noexpandtab
  au FileType go set shiftwidth=4
  au FileType go set softtabstop=4
  au FileType go set tabstop=4
]])

local function add_lines_to_term()
  local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = vim.api.nvim_get_current_buf() })
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

-- Disable comments continuation
vim.api.nvim_create_autocmd('BufWinEnter', {
  command = 'set formatoptions-=cro',
})
