local configs = require("plugins.configs.lspconfig")
local on_attach = configs.on_attach
local capabilities = configs.capabilities
local lspconfig = require "lspconfig"
-- find more https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  "html",
  "cssls",
  "clangd",
  "sourcekit",
  "gopls",
  "lemminx",
  "pyright",
  "dockerls",
  "helm_ls",
  "bashls",
  "cssmodules_ls",
  "angularls",
  "ansiblels",
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

