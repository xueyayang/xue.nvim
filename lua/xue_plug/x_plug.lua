-- lua/plugins/init.lua
-- 主插件配置文件

return {
  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup {
        ensure_installed = { "cpp" },
        sync_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      }

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 99
    end,
  },

  -- Telescope (文件和符号搜索)
  {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.2.1',
    lazy=true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- Telescope 键映射
    keys = {
      { '<A-S-o>', ':Telescope find_files<CR>',            desc = "Find files" },
      { '<A-S-s>', ':Telescope lsp_workspace_symbols<CR>', desc = "LSP Workspace Symbols" },
      { '<A-m>',   ':Telescope lsp_document_symbols<CR>',  desc = "Lsp list method" },
      { '<A-g>',   ':Telescope lsp_definitions<CR>',       desc = "LSP go to definition" },
      { '<A-b>',   ':Telescope buffers<CR>',               desc = "buffers" },
      { '<A-h>',   ':Telescope oldfiles<CR>',              desc = "history (oldfiles)" },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategy = 'vertical',
          layout_config = {
            vertical = { width = 0.618 }
          },
        },
        pickers = {
          lsp_document_symbols = {
            symbol_width = 0.8,
          },
        }
      }
    end,
  },

  -- Telescope FZF native
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install',
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },

  -- NERDTree (仅在终端环境中使用，GUI 使用内置 GuiTreeview，VSCode 不使用)
  {
    'preservim/nerdtree',
    enabled = not vim.g.vscode and not (vim.g.gui_running or vim.fn.has('gui_running') == 1),
    lazy = true,
    keys = {
      { '<F4>', '<cmd>NERDTreeToggle<cr>', desc = 'Toggle NERDTree' },
    },
    config = function()
      -- 插件配置（如果需要）
    end,
  },

  -- 文件图标
  { 'ryanoasis/vim-devicons' },
  { 'nvim-tree/nvim-web-devicons' },

  -- 自动补全
  {
    'saghen/blink.cmp',
    dependencies={'https://gitee.com/xueyayang/x_cmp_cn'},
    version = "1.*",
    opts = {
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'x_cmp_cn' },
        per_filetype = {
          c = { 'lsp' },
          cpp = { 'lsp' },
          text = { 'x_cmp_cn' },
          markdown = { 'x_cmp_cn' },
        },
        providers = {
          x_cmp_cn = {
            name = 'x_cmp_cn',
            module = 'x_cmp_cn'
          }
        },
      },
      keymap = { preset = 'super-tab' },
      completion = {
        documentation = { auto_show = true },
        list = {
          selection = {
            preselect = function(cmp)
              local blk = require('blink.cmp')
              return not blk.snippet_active()
            end
          }
        }
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    }
  },

  -- 自动配对
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup {}
    end,
  },

  -- 状态栏
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        tabline = { lualine_a = { 'buffers' } }
      }
    end,
  },

  -- 颜色主题
  { 'https://github.com/catppuccin/nvim',      name = 'catppuccin' },
  { 'https://github.com/joshdick/onedark.vim', name = 'onedark' },
  {
    'xueyayang/vsassist.nvim',
    config = function()
      vim.cmd([[colorscheme vsassist]])
    end,
  },
}
