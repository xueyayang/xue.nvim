-- init.luVG - 主配置入口文件

-- 设置 leader 键
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 检测并设置 GUI 环境变量（用于其他地方使用）
vim.g.gui_running = vim.fn.has('gui_running') == 1

-- 调试信息：打印环境检测结果
print("=== Neovim 环境检测 ===")
print("vim.g.vscode:", vim.g.vscode)
print("vim.fn.has('gui_running'):", vim.fn.has('gui_running'))
print("vim.g.gui_running (设置后):", vim.g.gui_running)

-- 安装 lazy.nvim
require('bootstrap')

-- 运行 lazy.nvim
require("lazy").setup({
    spec = {
        -- 自动导入 lua/xue_plug 文件夹下的所有模块
        { import = "xue_plug" },
    },
    install = { colorscheme = { "vsassist", "onedark", "default" } },
    checker = { enabled = false },
})

-- 根据环境加载相应的配置文件
if vim.g.vscode then
    -- VSCode
    print("→ 加载 VSCode 配置")
    require('vsc_nvim_init')
elseif vim.g.gui_running then
    -- nvim_qt (使用 has('gui_running') 检测)
    print("→ 加载 nvim_qt 配置")
    require('nvim_qt_init')
else
    -- 终端环境
    print("→ 加载终端配置")
    require('terminal_init')
end