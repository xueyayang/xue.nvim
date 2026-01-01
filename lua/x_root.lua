local M = {}

-- 查找项目根目录
function M.find_project_root(markers, startpath)
  -- 没找到任何 marker，尝试当前 buffer 所在文件夹
  local path = startpath or vim.fn.expand('%:p:h') -- or vim.loop.cwd()
  
  for _, marker in ipairs(markers) do
    -- 查找文件类型 marker
    local found_file = vim.fs.find(marker, { path = path, upward = true, type = "file" })
    if #found_file > 0 then
      return vim.fs.dirname(found_file[1])
    end

    -- 查找目录类型 marker
    local found_dir = vim.fs.find(marker, { path = path, upward = true, type = "directory" })
    if #found_dir > 0 then
      return vim.fs.dirname(found_dir[1])
    end
  end

  -- 都没有找到，返回 nil
  return path
end

-- 设置root
function M.set_root()
	local markers = { ".git", "compile_commands.json" }
	local root = M.find_project_root(markers);
	if root ~= nil and vim.loop.fs_stat(root) then
		-- 切换到 buffer 所在目录
		vim.cmd("tcd " .. root)
		vim.cmd("tcd .")
		vim.notify('Root decide: '..root, vim.log.levels.INFO)
	else
	 	-- 输出提示，失败
		vim.notify('Root deciding failed: ', vim.log.levels.WARN)
	end
end

function M.setup()
    vim.keymap.set('n', '<F3>', M.set_root, { desc = "Set project root" })
end

return M
