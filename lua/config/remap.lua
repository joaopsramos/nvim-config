local util = require('helper.utils')

if vim.g.neovide then
  util.keymap('n', '<SC-V>', '"+P')
  util.keymap('v', '<SC-c>', '"+y')
  util.keymap('n', '<SC-v>', '"+P')
  util.keymap('v', '<SC-v>', '"+P')
  util.keymap('c', '<SC-v>', '<C-r>+')
  util.keymap('i', '<SC-v>', '<C-r>+')
  util.keymap('t', '<SC-v>', '<C-\\><C-n>"+Pi')
end

-- General
util.keymap('n', '<C-q>', 'q')
util.keymap('n', 'q', ':q<CR>')
util.keymap('n', 'Q', ':Tclose!<CR>:quitall<CR>')
util.keymap('n', '<C-x>', ':bd<CR>')
util.keymap('n', '<leader>dab', ':%bd<CR>:e#<CR>', { desc = 'Delete all buffers except current' })

util.keymap('n', '<C-a>', 'ggVG', { desc = "Select all" })

util.keymap('n', '<C-s>', ':w<CR>')
util.keymap('i', '<C-s>', '<Esc>:w<CR>')
util.keymap('v', '<C-s>', ':w<CR>')

util.keymap('v', '<C-y>', '"+y')
util.keymap('i', '<C-p>', '<Left><C-o>p')
util.keymap('v', '<C-p>', 's<C-r>0<Esc>')
util.keymap('n', '<C-h>', ':noh<CR>')

util.keymap('i', '<C-j>', '<C-o>o')
util.keymap('i', '<C-z>', '<C-o>zz')

util.keymap('n', '&', 'yiw:%s/\\(<C-r>0\\)/\\/g<Left><Left>1', { silent = false })
util.keymap('v', '&', 'y:%s/\\(<C-r>0\\)/\\/g<Left><Left>1', { silent = false })

util.keymap('n', '<A-j>', ':m .+1<CR>')
util.keymap('n', '<A-k>', ':m .-2<CR>')
util.keymap('i', '<A-j>', '<Esc>:m .+1<CR>')
util.keymap('i', '<A-k>', '<Esc>:m .-2<CR>')
util.keymap('v', '<A-j>', ':m \'>+1<CR>')
util.keymap('v', '<A-k>', ':m \'<-2<CR>')

util.keymap('n', '<A-u>', '<C-w>p<C-u><C-w>p')
util.keymap('n', '<A-d>', '<C-w>p<C-d><C-w>p')

util.keymap('n', '<leader>so', 'vip:sort<CR>', { desc = "Sort lines" })

util.keymap('n', '<leader>gq', '<C-w>j:q<CR>', { desc = "" })

-- Terminal
util.keymap('t', '<C-\\>', '<C-\\><C-n>')
util.keymap('t', '<C-n>', '<C-\\><C-n><leader>tc')
util.keymap('t', '<Esc>', '<C-\\><C-n>:Tclose<CR>', { desc = "Close terminal" })
util.keymap('t', '<C-j>', '<C-\\><C-n><C-w>_')

-- Notify
util.keymap('n', '<leader>nd', ':lua require("notify").dismiss()<CR>', { desc = "Dismiss notifications" })

-- Neoterm
util.keymap('n', '<leader>tm', ':Ttoggle<CR><C-w><C-p>', { desc = "Toggle terminal" })
util.keymap('n', '<leader>to', ':Topen<CR><C-w><C-p>', { desc = "Open terminal" })
util.keymap('n', '<leader>tc', ':Tclose!<CR>', { desc = "Close terminal" })

-- Vim test
util.keymap('n', '<leader>tn', ':TestNearest<CR><leader>toG<C-w>p', { desc = "Test nearest", remap = true })
util.keymap('n', '<leader>tf', ':TestFile<CR><leader>toG<C-w>p', { desc = "Test file", remap = true })
util.keymap('n', '<leader>ts', ':TestSuite<CR><leader>toG<C-w>p', { desc = "Test suite", remap = true })
util.keymap('n', '<leader>tl', ':TestLast<CR><leader>toG<C-w>p', { desc = "Test last", remap = true })
util.keymap('n', '<leader>tv', ':TestVisit<CR>', { desc = "Test visit", remap = true })

-- Neo test
util.keymap('n', '<leader>nt', ":lua require('neotest').run.run()<CR>", { desc = 'Test nearest' })
util.keymap('n', '<leader>nf', ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = 'Test file' })
-- util.keymap('n', '<leader>nl', ":lua require('neotest').run.run_last({extra_args = '--failed'})<CR>",
--   { desc = 'Test failed' })
util.keymap('n', '<leader>nl', ":lua require('neotest').run.run_last()<CR>", { desc = 'Run last test' })
util.keymap('n', '<leader>ne', ":lua require('neotest').output.open({enter = true})<CR>", { desc = 'Open test output' })
util.keymap('n', '<leader>nc', ":lua require('neotest').output.open({enter = true, last_run = true})<CR>",
  { desc = 'Open output of last test run' })
util.keymap('n', '<leader>na', ":lua require('neotest').run.attach()<CR>", { desc = 'Attach to current running tests' })
util.keymap('n', '<leader>nb', ":lua require('neotest').summary.toggle()<CR>", { desc = 'Toggle test summary' })
util.keymap('n', '<leader>np', ":lua require('neotest').run.stop()<CR>", { desc = 'Stop running tests' })
util.keymap('n', '[t', ":lua require('neotest').jump.prev({ status = 'failed' })<CR>", { desc = 'Prev failed test' })
util.keymap('n', ']t', ":lua require('neotest').jump.next({ status = 'failed' })<CR>", { desc = 'Next failed test' })

-- File explorer
util.keymap('n', '<leader>b', function() Snacks.picker.explorer() end, { desc = 'Toggle NvimTree' })

-- Mix
util.keymap('n', '<leader>iex', "<leader>tmiiex<CR>", { desc = 'Run iex', remap = true })
util.keymap('n', '<leader>iem', "<leader>tmiiex -S mix<CR>", { desc = 'Run iex with mix', remap = true })
util.keymap('n', '<leader>iep', "<leader>tmiiex -S mix phx.server<CR>", { desc = 'Run phoenix server', remap = true })

-- Tabby
util.keymap('n', '<leader>tba', ':$tabnew<CR>')
util.keymap('n', '<leader>tbc', ':tabclose<CR>')
util.keymap('n', '<leader>tbo', ':tabonly<CR>')

-- fugitive
util.keymap('n', '<leader>gi', ':Git<CR><C-w>5-5j', { desc = 'Open git' })
util.keymap('', '<leader>gI', ':Git<space>', { desc = 'Run git command', silent = false })

util.keymap('', '<leader>gl', ':Git log<CR>', { desc = 'Git log' })

util.keymap('', '<leader>gci', ':Git commit -m ""<Left>', { desc = 'Git commit', silent = false })

util.keymap('n', '<leader>gP', ':Git push -u origin HEAD<CR>', { desc = 'Git push' })
util.keymap('n', '<leader>gp', ':Git pull<CR>', { desc = 'Git pull' })

util.keymap('n', '<leader>gsw', ':Git switch<space>', { desc = "Git switch", silent = false })
util.keymap('n', '<leader>gsb', ':Git switch --create<space>', { desc = "Git switch --create", silent = false })
util.keymap('n', '<leader>gsm', ':Git switch main<CR>', { desc = 'Git switch main' })
util.keymap('n', '<leader>gsn', ':Git switch next<CR>', { desc = 'Git switch next' })
util.keymap('n', '<leader>gsk', ':Git switch -<CR>', { desc = 'Git switch back' })

util.keymap('n', '<leader>gsth', ':Git stash<CR>', { desc = 'Git stash' })
util.keymap('n', '<leader>gsta', ':Git stash apply<CR>', { desc = 'Git stash apply' })
util.keymap('n', '<leader>gstp', ':Git stash pop<CR>', { desc = 'Git stash pop' })

util.keymap('n', '<leader>gbd', ':Git branch -d<space>', { desc = "Git branch -d", silent = false })
util.keymap('n', '<leader>gbD', ':Git branch -D<space>', { desc = "Git branch -D", silent = false })

util.keymap('n', '<leader>fh', ':Git log -p -- <C-r>%<CR>', { desc = "Git file history" })

-- Harpoon
util.keymap('n', '<leader>rm', ":lua require('harpoon.ui').toggle_quick_menu()<CR>", { desc = 'Harpoon quick menu' })
util.keymap('n', '<C-l>',
  ":lua require('harpoon.mark').add_file()<CR>:lua vim.api.nvim_notify('File added', vim.log.levels.INFO, {title = 'Harpoon'})<CR>",
  { desc = 'Harpoon add file' })
util.keymap('n', '<C-j>', ":lua require('harpoon.ui').nav_prev()<CR>", { desc = 'Harpoon nav prev' })
util.keymap('n', '<C-k>', ":lua require('harpoon.ui').nav_next()<CR>", { desc = 'Harpoon nav next' })

-- Hop
util.keymap('n', '<leader>j', ":HopWord<CR>", { desc = 'Jump' })

-- winresizer
util.keymap('n', '<C-t>', ":WinResizerStartResize<CR>", { desc = 'Start resize' })

-- winresizer
util.keymap('n', '<leader>u', ':UndotreeToggle<CR>:UndotreeFocus<CR>', { desc = 'Undotree toggle and focus' })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql" },
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<C-CR>", "vipBB", { noremap = false, silent = false })
  end
})
