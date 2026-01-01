-- x_opt.lua - 通用 vim.opt 配置

-- 终端/GUI 相关设置
vim.opt.title = true
vim.opt.showtabline = 2
vim.opt.clipboard = 'unnamedplus'

-- 基本编辑选项
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.backspace = 'indent,eol,start'
vim.opt.mouse = 'a' -- 鼠标支持,a 表示所有模式都支持，包括插入模式
vim.opt.cindent = true
vim.opt.textwidth = 1024
vim.opt.signcolumn = 'yes:2'

