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

  nnoremap <leader>tn <Cmd>lua require('vscode').call('testing.runAtCursor')<CR>
  nnoremap <leader>tf <Cmd>lua require('vscode').call('testing.runCurrentFile')<CR>
  nnoremap <leader>ts <Cmd>lua require('vscode').call('testing.runAll')<CR>
  nnoremap <leader>tl <Cmd>lua require('vscode').call('testing.reRunLastRun')<CR>

  noremap <leader>gci :Git commit -m ""<Left>

  nnoremap <leader>gP :Git push -u origin HEAD<CR>
  nnoremap <leader>gp :Git pull<CR>

  nnoremap <leader>gsw :Git switch<space>
  nnoremap <leader>gsb :Git switch --create<space>
  nnoremap <leader>gsm :Git switch main<CR>
  nnoremap <leader>gsn :Git switch next<CR>
  nnoremap <leader>gsbk :Git switch -<CR>

  nnoremap <leader>gsth :Git stash<CR>
  nnoremap <leader>gsta :Git stash apply<CR>
  nnoremap <leader>gstp :Git stash pop<CR>

  nnoremap <leader>gbd :Git branch -d<space>
  nnoremap <leader>gbD :Git branch -D<space>

  nnoremap <leader>fh :Git log -p -- <C-r>%<CR>

  vnoremap <leader>y "+y

  noremap gs <Cmd>lua require('vscode').action('workbench.action.gotoSymbol')<CR>
  noremap g/ <Cmd>lua require('vscode').action('workbench.action.findInFiles')<CR>

  noremap gy <Cmd>lua require('vscode').action('editor.action.goToTypeDefinition')<CR>
  noremap gI <Cmd>lua require('vscode').action('editor.action.goToImplementation')<CR>
  noremap cd <Cmd>lua require('vscode').action('editor.action.rename')<CR>
  noremap g. <Cmd>lua require('vscode').action('editor.action.quickFix')<CR>
  noremap <leader>gr <Cmd>lua require('vscode').action('editor.action.referenceSearch.trigger')<CR>
  noremap [d <Cmd>lua require('vscode').action('editor.action.marker.prev')<CR>
  noremap ]d <Cmd>lua require('vscode').action('editor.action.marker.next')<CR>
]])
