-- x_lsp.lua - LSP 服务器配置（使用 Neovim 内置 API）

-- 配置 clangd
vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index' },
  root_markers = { 'compile_commands.json' },
  filetypes = { 'cpp' },
})

-- 限制文件类型：只在 c/cpp 文件中启用 clangd
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.lsp.enable('clangd')
  end
})

-- 可以在这里添加其他 LSP 服务器的配置

