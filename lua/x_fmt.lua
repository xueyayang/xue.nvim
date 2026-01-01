local M = {}

-- fmt_block: 格式化光标所在的 block
function M.fmt_block(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  local ts = vim.treesitter
  local parsers = require("nvim-treesitter.parsers")

  -- 获取光标位置
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1 -- Lua index 从 0 开始

  -- 获取 parser
  if not parsers.has_parser() then return end
  local parser = parsers.get_parser(buf, parsers.get_buf_lang(buf))
  if not parser then return end
  local tree = parser:parse()[1]
  if not tree then return end

  -- 查找光标所在 node
  local root = tree:root()
  local node = root:named_descendant_for_range(row, col, row, col)

  -- 向上找最近 block（compound_statement 或 function_definition）
  while node do
    local type = node:type()
    if type == "compound_statement" or type == "function_definition" then
      break
    end
    node = node:parent()
  end
  if not node then return end

  -- 获取 block 范围
  local start_row, _, end_row, _ = node:range()

  -- 调用 LSP 格式化该 block
  vim.lsp.buf.format({
    async = true,
    range = {
      start = { start_row, 0 },
      ["end"] = { end_row + 1, 0 },
    },
  })
end


-- fmt_line: 格式化光标所在的当前行
function M.fmt_line(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  -- 获取光标行
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1  -- Lua index 从 0 开始

  -- 调用 LSP 格式化当前行
  vim.lsp.buf.format({
    async = true,
    range = {
      start = { row, 0 },
      ["end"] = { row + 1, 0 },
    },
  })
end

function M.setup()
    -- 插入模式按分号时格式化当前行
    --vim.keymap.set("i", ";", function()
    --  vim.api.nvim_feedkeys(";", "n", false)
    --  vim.defer_fn(function()
    --    M.fmt_line()
    --  end, 5)
    --end)

    -- 保存：保存 buffer 前格式化整个文件
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.c", "*.cpp", "*.h", "*.hpp" },
      callback = function()
        buf = vim.api.nvim_get_current_buf()
        vim.lsp.buf.format({
          async = true,
          bufnr = buf,
        })
      end,
    })
end

return M
