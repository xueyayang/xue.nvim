-- nvim_qt_init.lua - GUI 环境专用配置文件
-- 用于 nvim-qt 等图形界面环境

-- 加载通用配置
require('x_opt')
require('x_keymap')

-- 加载功能扩展配置
require('x_features')

-- F4 键绑定 GuiTreeviewToggle（GUI 环境使用内置文件树）
vim.keymap.set('n', '<F4>', ':GuiTreeviewToggle<CR>', { noremap = true, silent = true })