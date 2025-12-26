local map = require("utils").keymap

if vim.g.neovide then
  map("n", "<SC-V>", '"+P')
  map("v", "<SC-c>", '"+y')
  map("n", "<SC-v>", '"+P')
  map("v", "<SC-v>", '"+P')
  map("c", "<SC-v>", "<C-r>+")
  map("i", "<SC-v>", "<C-r>+")
  map("t", "<SC-v>", '<C-\\><C-n>"+Pi')
end

-- General
map("n", "<C-q>", "q")
map("n", "q", function()
  if #vim.api.nvim_list_wins() == 1 then
    return
  end

  vim.cmd("q")
end)
map("n", "Q", ":quitall<CR>")
map("n", "<C-x>", ":bd<CR>")
map("n", "<leader>dab", ":%bd<CR>:e#<CR>", { desc = "Delete all buffers except current" })

map("n", "<C-a>", "ggVG", { desc = "Select all" })

map({ "n", "i", "v" }, "<C-s>", "<Cmd>w<cr><Esc>")

map("v", "<C-y>", '"+y')
map("i", "<C-p>", "<Left><C-o>p")
map("v", "<C-p>", "s<C-r>0<Esc>")
map("n", "<Esc>", ":noh<CR>")

map("i", "<C-CR>", "<C-o>o")
map("i", "<C-z>", "<C-o>zz")

map("n", "&", "yiw:%s/\\(<C-r>0\\)/\\/g<Left><Left>1", { silent = false })
map("v", "&", "y:%s/\\(<C-r>0\\)/\\/g<Left><Left>1", { silent = false })

map("n", "<A-j>", ":m .+1<CR>")
map("n", "<A-k>", ":m .-2<CR>")
map("i", "<A-j>", "<Esc>:m .+1<CR>")
map("i", "<A-k>", "<Esc>:m .-2<CR>")
map("v", "<A-j>", ":m '>+1<CR>")
map("v", "<A-k>", ":m '<-2<CR>")

map("n", "<A-u>", "<C-w>p<C-u><C-w>p")
map("n", "<A-d>", "<C-w>p<C-d><C-w>p")

map("n", "<leader>so", "vip:sort<CR>", { desc = "Sort lines" })

-- better up/down with line wrapped
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Close bottom window
map("n", "<leader>gq", "<C-w>j:q<CR>", { desc = "" })

-- Notify
-- map('n', '<leader>nd', require("notify").dismiss, { desc = "Dismiss notifications" })

-- Mix
map("n", "<leader>iex", "<leader>tmiiex<CR>", { desc = "Run iex", remap = true })
map("n", "<leader>iem", "<leader>tmiiex -S mix<CR>", { desc = "Run iex with mix", remap = true })
map("n", "<leader>iep", "<leader>tmiiex -S mix phx.server<CR>", { desc = "Run phoenix server", remap = true })
