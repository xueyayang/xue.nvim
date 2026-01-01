-- x_keymap.lua - 通用键映射配置

-- 基础键映射（所有环境共用）
vim.keymap.set('n', '<Space><Space>', ':', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>f', '/', { noremap = true, silent = false })
vim.keymap.set('n', '<Leader>w', ':wa<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'cv', 'ct_', { noremap = true, silent = false })
vim.keymap.set('n', 'dv', 'dt_', { noremap = true, silent = false })
vim.keymap.set('n', 'cu', '<Esc>d/\\u<CR><Esc>:noh<CR>i', { noremap = true, silent = true })
vim.keymap.set('n', 'du', '<Esc>d/\\u<CR><Esc>:noh<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<A-l>', '<C-o>a', { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>q', ':wa<CR>:qa!<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'j', 'gj', { noremap = true, silent = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true, silent = true })
vim.keymap.set('n', '0', 'g0', { noremap = true, silent = true })
vim.keymap.set('n', '$', 'g$', { noremap = true, silent = true })
