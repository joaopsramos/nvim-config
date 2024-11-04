vim.cmd([[
  noremap q <Cmd>lua require('vscode').call('workbench.action.closeActiveEditor')<CR>
  noremap <leader>fm <Cmd>lua require('vscode').call('editor.action.formatDocument')<CR>

  noremap <C-h> <Cmd>noh<CR>
  noremap <C-a> ggVG

  noremap <leader>hr <Cmd>lua require('vscode').call('git.revertSelectedRanges')<CR>
  noremap <leader>hp <Cmd>lua require('vscode').action('editor.action.dirtydiff.next')<CR>

  noremap <leader>rm <Cmd>lua require('vscode').action('vscode-harpoon.editEditors')<CR>

  noremap <leader>tm <Cmd>lua require('vscode').call('workbench.action.terminal.toggleTerminal')<CR>

  nnoremap <leader>so vip:sort<CR>

  map <leader>tn <Cmd>lua require('vscode').call('extension.elixirRunTestAtCursor')<CR><leader>tm
  map <leader>tf <Cmd>lua require('vscode').call('extension.elixirRunTestFile')<CR><leader>tm
  map <leader>tl <Cmd>lua require('vscode').call('extension.elixirRunLastTestCommand')<CR><leader>tm
  map <leader>tv <Cmd>lua require('vscode').call('extension.elixirJumpToTest')<CR>

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

  nnoremap <leader>fh :Git log -p -- <C-r>%<CR>

  vnoremap <leader>y "+y
]])
