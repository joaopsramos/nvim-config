-- General
vim.cmd([[
  nnoremap <leader>re :so $MYVIMRC<CR>
  nnoremap <C-h> :noh<CR>
  vnoremap <C-y> "+y
  vnoremap <C-p> s<C-r>0<Esc>
  nnoremap <silent> <leader>dab :%bd<CR>:e#<CR>

  noremap q :q<CR>
  noremap <C-x> :bd<CR>

  xnoremap <leader>p "_dP

  inoremap <C-p> <Left><C-o>p
  inoremap <C-j> <C-o>o
  inoremap <C-z> <C-o>zz

  nnoremap & yiw:%s/\(<C-r>0\)/\/g<Left><Left>1
  vnoremap & y:%s/\(<C-r>0\)/\/g<Left><Left>1

  nnoremap <A-j> :m .+1<CR>
  nnoremap <A-k> :m .-2<CR>
  inoremap <A-j> <Esc>:m .+1<CR>
  inoremap <A-k> <Esc>:m .-2<CR>
  vnoremap <A-j> :m '>+1<CR>
  vnoremap <A-k> :m '<-2<CR>

  nnoremap <A-u> <C-w>p<C-u><C-w>p
  nnoremap <A-d> <C-w>p<C-d><C-w>p
]])

-- Exit with 'q'
vim.cmd([[ map Q :Tclose!<CR>:NvimTreeClose<CR>:quitall<CR> ]])

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
  tnoremap <C-j> <C-\><C-n><C-w>_
  tmap <C-n> <C-\><leader>tc
  tnoremap <C-\> <C-\><C-n>
]])

-- Notify
vim.cmd([[
  nnoremap <leader>nd :lua vim.notify.dismiss()<CR>
]])

-- Neoterm
vim.cmd([[
  nnoremap <silent> <leader>tm :Ttoggle<CR><C-w><C-p>
  nnoremap <silent> <leader>to :Topen<CR><C-w><C-p>
  nnoremap <leader>tc :Tclose!<CR>

  nnoremap <leader>twf :T find test lib \| entr -cr mix test %<CR>
  nnoremap <leader>tws :T find test lib \| entr -cr mix test %:<C-r>=line('.')<CR><CR>
]])

-- Vim test
vim.cmd([[
  nmap <leader>tn :TestNearest<CR><leader>toG<C-w>p
  nmap <leader>tf :TestFile<CR><leader>toG<C-w>p
  nmap <leader>ts :TestSuite<CR><leader>toG<C-w>p
  nmap <leader>tl :TestLast<CR><leader>toG<C-w>p
  nmap <leader>tv :TestVisit<CR>
]])

-- -- Neo test
-- vim.cmd([[
--   nnoremap <silent> <leader>nt :lua require('neotest').run.run()<CR>
--   nnoremap <silent><leader>nf :lua require('neotest').run.run(vim.fn.expand('%'))<CR>
--   nnoremap <silent> <leader>nd :lua require('neotest').run.run({extra_args = '--failed'})<CR>
--   nnoremap <silent> <leader>ne :lua require('neotest').output.open({enter = true})<CR>
--   nnoremap <silent> <leader>na :lua require('neotest').output.open({enter = true, last_run = true})<CR>
--   nnoremap <silent> <leader>nc :lua require('neotest').run.attach()<CR>
--   nnoremap <silent> <leader>nb :lua require("neotest").summary.toggle()<CR>
--   nnoremap <silent> [t :lua require("neotest").jump.prev({ status = 'failed' })<CR>
--   nnoremap <silent> ]t :lua require("neotest").jump.next({ status = 'failed' })<CR>
-- ]])

-- Nvimtree
vim.cmd([[
  nnoremap <silent> <leader>b :NvimTreeFindFileToggle<CR>
]])

-- Mix
vim.cmd([[
  nmap <leader>iex <leader>tmiiex<CR>
  nmap <leader>iem <leader>tmiiex --no-pry -S mix<CR>
  nmap <leader>iep <leader>tmiiex --no-pry -S mix phx.server<CR>
]])

-- Tabby
vim.cmd([[
  nnoremap <leader>tba :$tabnew<CR>
  nnoremap <leader>tbc :tabclose<CR>
  nnoremap <leader>tbo :tabonly<CR>
]])

-- fugitive
vim.cmd([[
  nnoremap <silent> <leader>gi :Git<CR><C-w>5-5j
  noremap <leader>gI :Git<space>

  noremap <leader>gl :Git log<CR>

  noremap <leader>gci :Git commit -m ""<Left>

  nnoremap <leader>gP :Git push -u origin HEAD<CR>
  nnoremap <leader>gp :Git pull<CR>

  nnoremap <leader>gsw :Git switch<space>
  nnoremap <leader>gsb :Git switch --create<space>
  nnoremap <leader>gsm :Git switch main<CR>
  nnoremap <leader>gsbk :Git switch -<CR>

  nnoremap <leader>gsth :Git stash<CR>
  nnoremap <leader>gsta :Git stash apply<CR>
  nnoremap <leader>gstp :Git stash pop<CR>

  nnoremap <leader>gbd :Git branch -d<space>
  nnoremap <leader>gbD :Git branch -D<space>

  nmap <leader>gq <C-w>jq

  nnoremap <leader>fh :Git log -p -- <C-r>%<CR>
]])

-- Harpoon
vim.cmd([[
  nnoremap <silent> <leader>rm :lua require("harpoon.ui").toggle_quick_menu()<CR>
  nnoremap <C-l> :lua require("harpoon.mark").add_file()<CR>
  nnoremap <silent> <C-j> :lua require("harpoon.ui").nav_prev()<CR>
  nnoremap <silent> <C-k> :lua require("harpoon.ui").nav_next()<CR>
]])

-- Hop
vim.cmd([[
  nnoremap <silent> t :HopWord<CR>
]])
