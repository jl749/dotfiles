-- nvim/lua/options.lua

-- space leaderkey
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- sync system clipboard with vim register
-- :help clipboard
vim.o.clipboard = 'unnamed'

vim.o.number = true
vim.o.relativenumber = true

vim.o.signcolumn = 'yes'

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.updatetime = 300

vim.o.termguicolors = true

vim.o.mouse = ''

-- custom keymaps
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal' })
vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { desc = 'Show diagnostic: error message' })
vim.keymap.set('n', 'gH', vim.diagnostic.setloclist, { desc = 'Open diagnostic: quickfix' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left pane' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right pane' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower pane' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper pane' })
