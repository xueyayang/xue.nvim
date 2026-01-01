-- 文件名: x_switch_cpp_h.lua
-- 功能: 在当前 buffer 的 C/C++ 文件间切换头/实现

local M = {}

-- 支持的扩展名
local ext_map = {
	h = {"cpp", "cxx", "cc", "c"},
	hpp = {"cpp", "cxx", "cc", "c"},
	cpp = {"h", "hpp"},
	cxx = {"h", "hpp"},
	cc = {"h", "hpp"},
	c = {"h", "hpp"},
}

-- 获取文件名不带路径和后缀
local function basename_no_ext(filepath)
	local name = vim.fn.fnamemodify(filepath, ":t")
	return name:match("(.+)%..+$") or name
end

-- 获取文件扩展名
local function get_ext(filepath)
	return filepath:match("%.([^.]+)$")
end

-- 在指定目录用 fd 查找文件
local function find_file(base, exts, cwd)
	cwd = cwd or vim.loop.cwd()
	local n_ext = "-e "..table.concat(exts, " -e ")
	-- fd.exe -e ext1 -e ext2  base path
	local cmd = string.format('fd.exe %s %s %s', n_ext, base, cwd)
	local handle = io.popen(cmd)
	if handle then
		local result = handle:read("*a")
		handle:close()
		for line in result:gmatch("[^\r\n]+") do
			return line  -- 找到第一个返回
		end
	else
		print("handle nil")
		end
	return nil
end

-- 核心切换函数
function M.switch_header_impl()
	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" then
		print("No file detected")
		return
	end

	local base = basename_no_ext(filepath)
	local ext = get_ext(filepath) -- 这里获取到的是当当前buffer的文件后缀

	if not ext_map[ext] then
		print("Unsupported file type:", ext)
		return
	end

	local target = find_file(base, ext_map[ext]) -- 这里有没有反转？src->header, or header->src?
	if target then
		vim.cmd("edit " .. target)
	else
		print("Corresponding file not found for: \n\t"..filepath.."\n\t Note cwd: "..vim.loop.cwd().."\n\t Note vim.fn.executable(\"fd.exe\") return:"..vim.fn.executable("fd.exe"))
	end
end

-- 创建命令和快捷键
function M.setup()
	vim.api.nvim_create_user_command("SwitchCppH", M.switch_header_impl, {})
	vim.keymap.set("n", "<A-o>", M.switch_header_impl, {desc="Switch C++ header/impl"})
end

return M


