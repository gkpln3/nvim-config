---@type ChadrcConfig
local M = {}
M.ui = { theme = 'onedark' }
M.plugins = "custom.plugins"

vim.opt.relativenumber = true

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

return M
