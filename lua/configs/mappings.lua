-- General
vim.cmd([[
  nnoremap G Gzz
  nnoremap <leader>sv :source $MYVIMRC<CR>
]])

-- Exit with 'q'
vim.cmd([[ map Q :Tclose!<CR>:q<CR> ]])

-- Save with 'Ctrl + s' on Normal, Insert and Visual modes
-- Precisa adicionar a linha: stty -ixon , ao seu ~/.bashrc
vim.cmd([[nnoremap <C-s> :w<CR>]])
vim.cmd([[inoremap <C-s> <Esc>:w<CR>l]])
vim.cmd([[vnoremap <C-s> <Esc>:w<CR>]])

-- Select all with 'Ctrl + a'
vim.cmd([[ map <C-a> ggVG ]])

-- Terminal
vim.cmd([[ 
  tmap <Esc> <C-\><C-n><leader>tt<Esc>
  tnoremap <C-j> <C-\><C-n><C-w>_i
]])

-- Telescope
vim.cmd([[
  nnoremap <leader><Space> <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>g <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
]])

-- BufferLine
vim.cmd([[
  nnoremap <silent>]b :BufferLineCycleNext<CR>
  nnoremap <silent>[b :BufferLineCyclePrev<CR>

  map q :bd<CR>
]])

-- Neoterm
vim.cmd([[
  nnoremap <silent> <leader>tt :Ttoggle<CR><C-w><C-j>i
  nnoremap <leader>tc :Tclose!<CR>

  nnoremap <leader>alt :A<CR>

  nnoremap <leader>tn :call TestInNeoterm('tn')<CR>
  nnoremap <leader>tf :call TestInNeoterm('tf')<CR>
  nnoremap <leader>ts :call TestInNeoterm('ts')<CR>
  nnoremap <leader>tl :call TestInNeoterm('tl')<CR>
  nnoremap <leader>tv :TestVisit<CR>

  nnoremap <leader>twf :T find test lib \| entr -cr mix test %<CR>
  nnoremap <leader>tws :T find test lib \| entr -cr mix test %:<C-r>=line('.')<CR><CR>
]])

-- Nvimtree
vim.cmd([[
  nnoremap <silent> <leader>b :NvimTreeToggle<CR>
]])

-- Split
vim.cmd([[
  nnoremap <C-j> <C-W>j
  nnoremap <C-k> <C-W>k
  nnoremap <C-l> <C-W>l
  nnoremap <C-h> <C-W>h
]])