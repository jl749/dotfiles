-- nvim/after/plugin/telescope.lua

-- e.g. :Telescope find_files
local builtin = require('telescope.builtin')
require('telescope').setup({
  pickers = { find_files = { hidden = true } },
  defaults = {
    mappings = {
      i = {
        ['<A-j>'] = 'move_selection_next',
        ['<A-k>'] = 'move_selection_previous',
        ['<esc>'] = 'close'
      }
    }
  }
})
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
