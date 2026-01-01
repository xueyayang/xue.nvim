-- x_features.lua - 终端/GUI 环境共用的功能扩展配置

-- LSP 配置
require('x_lsp')

-- 输入法切换命令
vim.api.nvim_create_user_command("XImToggle", function(opts)
  require('x_im_toggle').toggle(opts)
end, { nargs = 1, complete = function() return { "cn", "en" } end })

-- 快捷键触发
vim.keymap.set('n', '<Leader>cn', ':XImToggle cn<CR>', { silent = true, desc = "开启中文模式" })
vim.keymap.set('n', '<Leader>en', ':XImToggle en<CR>', { silent = true, desc = "切换英文模式" })

-- Alt+Up/Down，移动行
require('x_move').setup()

-- <Leader>a=，对齐=号
require('x_align').setup()

-- F3，查找当前root
require('x_root').setup()

-- Alt-o，切换头文件
require('x_switch_src_h').setup()

-- 格式化时机
require('x_fmt').setup()
