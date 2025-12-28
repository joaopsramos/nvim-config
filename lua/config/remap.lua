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

map("n", "<C-q>", ":q<CR>", { desc = "Close window" })
map("n", "<C-x>", ":bd<CR>", { desc = "Close buffer" })
map("n", "ZZ", ":quitall<CR>", { desc = "Close buffer" })
map("n", "<leader>dab", ":%bd|e#<CR>", { desc = "Delete all buffers except current" })

-- close bottom window if any
map("n", "<leader>gq", function()
  if #vim.api.nvim_list_wins() == 1 then
    return
  end

  vim.cmd("wincmd j")
  vim.cmd("quit")
end, { desc = "Close bottom window" })

map("n", "<C-a>", "ggVG", { desc = "Select all" })

map({ "n", "i", "v" }, "<C-s>", "<Cmd>w<CR><Esc>")

map("v", "<C-y>", '"+y', { desc = "Copy to clipboard" })
map({ "n", "x" }, "cy", '"+y', { desc = "Copy to clipboard" })
map("i", "<C-p>", "<Left><C-o>p")
map("v", "<C-p>", "s<C-r>0<Esc>")

map({ "n", "v" }, "/", "/\\v", { silent = false })
map({ "n", "v" }, "?", "?\\v", { silent = false })
map("n", "<Esc>", ":noh<CR>")

map("i", "<C-CR>", "<C-o>o")
map("i", "<C-z>", "<C-o>zz")

-- Find and Replace current word
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

-- Splits
map("n", "<leader>-", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>/", "<C-w>s", { desc = "Split window horizontally" })

-- Terminal
map("t", "<C-\\>", "<C-\\><C-n>")
map("t", "<Esc>", "<C-\\><C-n>:close<CR>", { desc = "Close terminal" })
map("t", "<C-j>", "<C-\\><C-n><C-w>_")

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

-- Mix
map("n", "<leader>iex", "<C-t>iiex<CR>", { desc = "Run iex", remap = true })
map("n", "<leader>iem", "<C-t>iiex -S mix<CR>", { desc = "Run iex with mix", remap = true })
map("n", "<leader>iep", "<C-t>iiex -S mix phx.server<CR>", { desc = "Run phoenix server", remap = true })
