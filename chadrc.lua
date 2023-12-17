---@type ChadrcConfig
local M = {}
M.ui = { theme = 'onedark' }
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

vim.opt.relativenumber = true

-- Configure copy paste to use system clipboard
local function copy(lines, _)
  require('osc52').copy(table.concat(lines, '\n'))
end

local function paste()
  return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
end

vim.g.clipboard = {
  name = 'osc52',
  copy = {['+'] = copy, ['*'] = copy},
  paste = {['+'] = paste, ['*'] = paste},
}

-- When vim opens, use the directory given as an argument
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        local args = vim.v.argv
        if args[3] and vim.fn.isdirectory(args[3]) == 1 then
            vim.cmd('cd ' .. vim.fn.fnameescape(args[3]))
        end

        if vim.fn.argc() > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
            vim.api.nvim_command('NvimTreeFocus')
        end
    end,
})

-- Make double click select whole words including - and .
vim.opt.iskeyword:append("-")
vim.opt.iskeyword:append(".")

vim.g.copilot_assume_mapped = true

-- Disable tab for cmp since it is used for copilot
local present, cmp = pcall(require, "cmp")
if present then
  local function no_action(fallback)
    fallback()
  end
  cmp.setup({
    mapping = {
      ['<Tab>'] = no_action,
      ['<S-Tab>'] = no_action,
      ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    },
  })
end

return M
