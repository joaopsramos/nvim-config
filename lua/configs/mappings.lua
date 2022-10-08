-- General
vim.cmd([[
  nnoremap <leader>re :so $MYVIMRC<CR>
  nnoremap <C-h> :noh<CR>
  vnoremap <C-p> s<C-r>0<Esc>
  vnoremap <C-y> "+y
  nnoremap <silent> <leader>dab :%bd<CR>:e#<CR>

  xnoremap <leader>p "_dP

  inoremap <C-p> <Left><C-o>p
  inoremap <C-j> <C-o>o

  nnoremap & yiw:%s/\(<C-r>0\)/\1
  vnoremap & y:%s/\(<C-r>0\)/\1

  nnoremap <A-j> :m .+1<CR>
  nnoremap <A-k> :m .-2<CR>
  inoremap <A-j> <Esc>:m .+1<CR>
  inoremap <A-k> <Esc>:m .-2<CR>
  vnoremap <A-j> :m '>+1<CR>
  vnoremap <A-k> :m '<-2<CR>
]])

-- Exit with 'q'
vim.cmd([[ map Q :Tclose!<CR>:quitall<CR> ]])

-- Save with 'Ctrl + s' on Normal, Insert and Visual modes
-- Precisa adicionar a linha: stty -ixon , ao seu ~/.bashrc
vim.cmd([[
  nnoremap <C-s> :w<CR>
  inoremap <C-s> <Esc>:w<CR>l
  vnoremap <C-s> <Esc>:w<CR>
]])

-- Select all with 'Ctrl + a'
vim.cmd([[ map <C-a> ggVG ]])

-- Terminal
vim.cmd([[ 
  tmap <Esc> <C-\>:Ttoggle<CR><C-w>p
  tnoremap <C-j> <C-\><C-n><C-w>_i
  tmap <C-n> <C-\><leader>tc
  tnoremap <C-\> <C-\><C-n>
]])

-- Telescope
vim.cmd([[
  nnoremap <leader>fi <cmd>lua require('telescope.builtin').find_files()<cr>
  nnoremap <leader>gr <cmd>lua require('telescope.builtin').live_grep()<cr>
  nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
  nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
]])

-- BufferLine
vim.cmd([[
  nnoremap <silent>]b :BufferLineCycleNext<CR>
  nnoremap <silent>[b :BufferLineCyclePrev<CR>

  noremap q :q<CR>
]])

-- Neoterm
vim.cmd([[
  nnoremap <silent> <leader>tm :Ttoggle<CR><C-w><C-j>
  nnoremap <silent> <leader>to :Topen<CR><C-w><C-j>
  nnoremap <leader>tc :Tclose!<CR>

  nnoremap <leader>twf :T find test lib \| entr -cr mix test %<CR>
  nnoremap <leader>tws :T find test lib \| entr -cr mix test %:<C-r>=line('.')<CR><CR>
]])

-- Vim test
vim.cmd([[
  nmap <leader>tn :TestNearest<CR><leader>toG
  nmap <leader>tf :TestFile<CR><leader>toG
  nmap <leader>ts :TestSuite<CR><leader>toG
  nmap <leader>tl :TestLast<CR><leader>toG
  nmap <leader>tv :TestVisit<CR>
]])

-- Nvimtree
vim.cmd([[
  nnoremap <silent> <leader>b :NvimTreeToggle<CR>
]])

-- Mix
vim.cmd([[
  nmap <leader>iex <leader>ttiiex<CR>
  nmap <leader>iem <leader>ttiiex -S mix<CR>
  nmap <leader>iep <leader>ttiiex -S mix phx.server<CR>
]])

-- Split
-- vim.cmd([[
--   nnoremap <C-j> <C-W>j
--   nnoremap <C-k> <C-W>k
--   nnoremap <C-l> <C-W>l
--   nnoremap <C-h> <C-W>h
-- ]])

-- Tabby
vim.cmd([[
  nnoremap <leader>tba :$tabnew<CR>
  nnoremap <leader>tbc :tabclose<CR>
  nnoremap <leader>tbo :tabonly<CR>
]])


-- fugitive
vim.cmd([[
  nnoremap <silent> <leader>gi :Git<CR>

  noremap <leader>gl :Git log<CR>
    
  noremap <leader>gci :Git commit -m ""<Left>

  nnoremap <leader>gP :Git push -u origin HEAD<CR>
  nnoremap <leader>gp :Git pull<CR>

  nnoremap <leader>gsw :Git switch 
  nnoremap <leader>gsb :Git switch --create 
  nnoremap <leader>gsm :Git switch main<CR>
  nnoremap <leader>gsbk :Git switch -<CR>
  
  nnoremap <leader>gsth :Git stash<CR>
  nnoremap <leader>gsta :Git stash apply<CR>
  nnoremap <leader>gstp :Git stash pop<CR>

  nnoremap <leader>gbd :Git branch -d 
  nnoremap <leader>gbD :Git branch -D 

  nmap <leader>gq <C-w>jq

  nnoremap <leader>fh :Git log -p -- <C-r>%<CR>
]])
