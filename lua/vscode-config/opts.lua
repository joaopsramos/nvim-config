vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.g.clipboard = vim.g.vscode_clipboard

vim.cmd([[
    au TextYankPost * silent! lua vim.highlight.on_yank()
]])
