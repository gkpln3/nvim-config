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
    lazy = false
  }
}

return plugins
