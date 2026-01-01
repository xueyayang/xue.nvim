local api = vim.api

local M = {}

local function align(firstline, lastline)
    -- 获取行内容（0-based，左闭右开）
    local all_lines = api.nvim_buf_get_lines(0, firstline - 1, lastline, false)
    if #all_lines == 0 then return end

    -- 查找最大等号位置
    local max_pos = 0
    for _, line in ipairs(all_lines) do
        local eq_pos = string.find(line, "=")
        if eq_pos and eq_pos > max_pos then
            max_pos = eq_pos
        end
    end

    if max_pos == 0 then return end  -- 没有等号，无需对齐

    -- 构建新行
    local new_lines = {}
    for i, line in ipairs(all_lines) do
        local eq_pos = string.find(line, "=")
        if eq_pos and eq_pos < max_pos then
            local prefix = line:sub(1, eq_pos - 1)
            local suffix = line:sub(eq_pos)
            local spaces = string.rep(' ', max_pos - eq_pos)
            new_lines[i] = prefix .. spaces .. suffix
        else
            new_lines[i] = line
        end
    end

    -- 一次性写回
    api.nvim_buf_set_lines(0, firstline - 1, lastline, false, new_lines)
end

-- 可视模式对齐函数
function M.align_visual(opts)
  local firstline = opts.line1
  local lastline = opts.line2
  align(firstline, lastline)
end

-- Setup 函数
function M.setup()
  -- 创建用户命令
  vim.api.nvim_create_user_command('XAlign', M.align_visual,
  {
    nargs = 0,
    range = true,
    desc = "对齐选中行中的等号",
  })

  -- 映射快捷键
  vim.keymap.set('v', '<Leader>a=', ':XAlign<CR>', { noremap = true, silent = true, desc = "对齐等号" })
end

return M
