-- x_im_toggle.lua
local M = {}

-- 延迟加载的变量
local ffi, user32, imm32
local VK_SHIFT = 0x10
local VK_CONTROL = 0x11
local KEYEVENTF_KEYUP = 0x0002
local WM_IME_CONTROL = 0x0283
local IMC_SETOPENSTATUS = 0x0006
local IMC_GETOPENSTATUS = 0x0005

-- 状态变量
local to_cn = false
local is_initialized = false

-- ---------------------------------------------------------
-- Windows API 封装 (保留作为技术文档)
-- ---------------------------------------------------------

local function init_ffi()
    if is_initialized then return end
    ffi = require("ffi")
    ffi.cdef[[
        typedef void* HWND;
        typedef unsigned long WPARAM;
        typedef long LPARAM;
        typedef long LRESULT;
        HWND GetForegroundWindow();
        HWND ImmGetDefaultIMEWnd(HWND hwnd);
        LRESULT SendMessageA(HWND hWnd, unsigned int Msg, WPARAM wParam, LPARAM lParam);
        void keybd_event(unsigned char bVk, unsigned char bScan, unsigned long dwFlags, void* dwExtraInfo);
    ]]
    user32 = ffi.load("user32")
    imm32 = ffi.load("imm32")
    is_initialized = true
end

local function getIme()
    local hwnd = user32.GetForegroundWindow()
    return imm32.ImmGetDefaultIMEWnd(hwnd)
end

local function setIme(status)
    local ime = getIme()
    user32.SendMessageA(ime, WM_IME_CONTROL, IMC_SETOPENSTATUS, ffi.cast("LPARAM", status))
end

-- 特别保留：文档化函数
-- 测试发现，0 会进入“五笔”的英文模式，1 不会改变。
-- 这是处理 Windows IME 状态切换的核心细节。
local function inactivateIm()
    setIme(0)
end

local function activateIm()
    setIme(1)
end

local function presstKey()
    if to_cn then
        user32.keybd_event(VK_CONTROL, 0, 0, nil)
        user32.keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, nil)
    end
end

-- ---------------------------------------------------------
-- 业务逻辑
-- ---------------------------------------------------------

local function apply_mode(mode)
    if mode == "cn" then
        to_cn = true
        vim.notify("IM: 中文模式 (Insert 自动切中文)")
    else
        to_cn = false
        vim.notify("IM: 英文模式 (保持系统当前状态)")
    end
end

-- 只有在插件加载后才会运行的 FileType 检测
local function check_file_type()
    local ft = vim.bo.filetype
    vim.notify("IM: check_file_type:"..ft)
    if ft == "markdown" or ft == "text" then
        apply_mode("cn")
    else
        apply_mode("en")
    end
end

function M.setup(initial_mode)
    init_ffi()

    -- 1. 注册 Esc 自动切换英文 (核心功能)
    vim.keymap.set('i', '<Esc>', function()
        inactivateIm()
        return "<Esc>"
    end, { noremap = true, silent = true, expr = true })

    -- 2. 注册 InsertEnter 自动切中文
    vim.api.nvim_create_autocmd("InsertEnter", {
        group = vim.api.nvim_create_augroup("XueGroup", { clear = true }),
        callback = function()
            if to_cn then presstKey() end
        end
    })

    -- 3. 注册 BufEnter 事件, 切换buf 自动检测 filetype
    -- 此时插件已加载，监听 FT 的开销极小
    vim.api.nvim_create_autocmd("BufEnter", {
        group = "XueGroup",
        callback = check_file_type
    })

    -- 4. 执行初始模式设置
    apply_mode(initial_mode)
end

-- 统一的命令入口
function M.toggle(opts)
    local mode = opts.args
    if not is_initialized then
        M.setup(mode)
    else
        apply_mode(mode)
    end
end

return M
