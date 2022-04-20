-- Exit with 'q'
vim.cmd([[ map q :q<CR> ]])

-- Save with 'Ctrl + s' on Normal, Insert and Visual modes
-- Precisa adicionar a linha: stty -ixon , ao seu ~/.bashrc
vim.cmd([[ nnoremap <C-s> :w<CR> ]])
vim.cmd([[ inoremap <C-s> <Esc>:w<CR>l ]])
vim.cmd([[ vnoremap <C-s> <Esc>:w<CR> ]])

-- Select all with 'Ctrl + a'
vim.cmd([[ map <C-a> ggVG ]])

-- Telescope
vim.cmd([[
  nnoremap <leader><Space> <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
]])

-- BufferLine
vim.cmd([[
  nnoremap <silent>b[ :BufferLineCycleNext<CR>
  nnoremap <silent>b] :BufferLineCyclePrev<CR>

  nnoremap <silent>[b :BufferLineMoveNext<CR>
  nnoremap <silent>]b :BufferLineMovePrev<CR>
]])
