-- nvim/after/plugin/cmp.lua

local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<M-j>'] = cmp.mapping.select_next_item(),
    ['<M-k>'] = cmp.mapping.select_prev_item(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- suggestions from active LSPs
  })
})
