local overrides = require "custom.configs.overrides"

local plugins = {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "ojroques/nvim-osc52",
    lazy = false,
  },
  {
    "github/copilot.vim",
    lazy = false,
  },
  {
    "RRethy/vim-illuminate",
    lazy = false,
    autostart = true,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
  },
  {
    "lewis6991/whatthejump.nvim",
    lazy = false,
  },
  {
    "tpope/vim-fugitive",
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },
  -- {
  --   "L3MON4D3/LuaSnip",
  --   enabled = false
  -- },
  {
    "junegunn/vim-easy-align",
    lazy = false,
  },
  {
    "petertriho/nvim-scrollbar",
    lazy = false,
    autostart = true,
  },
  {
    "kevinhwang91/nvim-hlslens",
    config = function()
      -- require('hlslens').setup() is not required
      require("scrollbar.handlers.search").setup {
        -- hlslens config overrides
      }
    end,
    lazy = false,
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = {
      actions = {
        open_file = {
          resize_window = false,
        },
      },
      renderer = {
        root_folder_label = true,
        highlight_git = true,
        icons = {
          show = {
            git = true,
          },
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = {
      snippet = nil,
    },
  },
  {
    "mhartington/formatter.nvim",
    lazy = false,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      automatic_installation = true,
    },
  },
  {
    "sbdchd/neoformat",
    lazy = false,
  },
  {
    "rafamadriz/friendly-snippets",
    enabled = false,
  },
  {
    "nvchad.tabufline",
    enabled = false,
  }
}

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = { "src/parser.c" },
  },
  filetype = "gotmpl",
  used_by = { "gotext", "gotemplate", "yaml", "tpl", "gohtmltmpl" },
}

return plugins
