local overrides = require("custom.configs.overrides")

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
    lazy = false
  },
  {
    "github/copilot.vim",
    lazy = false
  },
  {
    "RRethy/vim-illuminate",
    lazy = false,
    autostart = true
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
  },
  {
    "lewis6991/whatthejump.nvim",
    lazy = false
  },
  {
    "tpope/vim-fugitive",
    lazy = false
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  -- {
  --   "hrsh7th/nvim-cmp",
  --   opts = {
  --     mappings = {
  --     ["<C-d>"] = require("cmp").scroll_docs(-4),
  --     ["<C-f>"] = require("cmp").scroll_docs(4),
  --     ["<Down>"] = require("cmp").select_next_item(),
  --     ["<Up>"] = require("cmp").select_prev_item(),
  --     ["<C-Space>"] = require("cmp").complete(),
  --     ["<C-n>"] = require("cmp").next_source(),
  --     ["<C-p>"] = require("cmp").prev_source(),
  --   },
};

local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
parser_configs.gotmpl = {
  install_info = {
    url = "https://github.com/ngalaiko/tree-sitter-go-template",
    files = {"src/parser.c"}
  },
  filetype = "gotmpl",
  used_by = {"gotext", "gotemplate", "yaml", "tpl", "gohtmltmpl"}
}

return plugins
