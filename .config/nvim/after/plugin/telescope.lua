-- nvim/after/plugin/telescope.lua

require('telescope').setup({
  pickers = { find_files = { hidden = true } },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case', -- 'ignore_case' or 'respect_case'
    }
  },
  defaults = {
    mappings = {
      i = {
        ["<A-j>"] = "move_selection_next",
        ["<A-k>"] = "move_selection_previous",
        ["<esc>"] = "close"
      }
    }
  }
})

require('telescope').load_extension('fzf')

-- e.g. :Telescope find_files
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
