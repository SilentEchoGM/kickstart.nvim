local ls = require 'luasnip'

vim.keymap.set('i', '<C-l>', function()
  ls.jump(1)
end, { silent = true })
vim.keymap.set('i', '<C-h>', function()
  ls.jump(-1)
end, { silent = true })

return {}
