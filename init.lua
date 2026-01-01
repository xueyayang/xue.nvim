-- init.luVG - 主配置入口文件

-- 设置 leader 键
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 检测并设置 GUI 环境变量（用于其他地方使用）
vim.g.gui_running = vim.fn.has('gui_running') == 1

-- 调试信息：使用 vim.notify 静默输出（不会触发 Press ENTER 提示）
-- 如果需要查看，可以使用 :messages 命令
vim.schedule(function()
  local env_info = string.format(
    "环境检测: vscode=%s, gui_running=%s, gui_running_set=%s",
    tostring(vim.g.vscode),
    tostring(vim.fn.has('gui_running')),
    tostring(vim.g.gui_running)
  )
  vim.notify(env_info, vim.log.levels.INFO, { title = "Neovim 启动" })
end)

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
local env_name
if vim.g.vscode then
    -- VSCode
    env_name = "VSCode"
    require('vsc_nvim_init')
elseif vim.g.gui_running then
    -- nvim_qt (使用 has('gui_running') 检测)
    env_name = "nvim_qt"
    require('nvim_qt_init')
else
    -- 终端环境
    env_name = "终端"
    require('terminal_init')
end

-- 静默记录加载的配置（使用 vim.notify，不会触发 Press ENTER）
vim.schedule(function()
  vim.notify("加载 " .. env_name .. " 配置", vim.log.levels.INFO)
end)