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

vim.opt.iskeyword:append("-")
vim.opt.iskeyword:append(".")
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

M.mappings = require "custom.mappings"
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

 function live_grep_in_nvimtree_directory()
    local is_nvimtree_open = pcall(vim.api.nvim_buf_get_var, 0, 'nvim_tree')

    if is_nvimtree_open then
        -- Get the path of the selected item in NvimTree
        local lib = require('nvim-tree.lib')
        local node = lib.get_node_at_cursor()
        local path = node.absolute_path

        -- Check if the path is a directory
        if node.entries ~= nil then
            require('telescope.builtin').live_grep({ search_dirs = {path} })
        else
            print('Selected item is not a directory')
        end
    else
        print('NvimTree is not focused')
    end
end

-- Key mapping to invoke the function
vim.api.nvim_set_keymap('n', '<leader>fw', ':lua live_grep_in_nvimtree_directory()<CR>', { noremap = true, silent = true })

return M
