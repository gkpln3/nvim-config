local M = {}
 function live_grep_in_nvimtree_directory()
    local nvim_tree_bufnr = vim.fn.bufnr('NvimTree_1')
    local current_bufnr = vim.api.nvim_get_current_buf()
    if current_bufnr == nvim_tree_bufnr then
      -- Get the path of the selected item in NvimTree
      local lib = require('nvim-tree.lib')
      local node = lib.get_node_at_cursor()
      local path = node.absolute_path

      -- Check if the path is a directory
      if node and node.absolute_path and vim.fn.isdirectory(node.absolute_path) == 1 then
          require('telescope.builtin').live_grep({ search_dirs = {path} })
      else
        require('telescope.builtin').live_grep({ search_dirs = {path} })
      end
    else
      require('telescope.builtin').live_grep({ search_dirs = {path} })
    end
end

function live_grep_in_directory()
    local input_opts = {
      prompt = 'Enter Directory To Grep In: ',
      default = '',
      completion = 'dir',
    }

    -- Ask for the directory
    local dir = vim.fn.input(input_opts)

    -- Run Telescope live_grep in the specified directory
    require('telescope.builtin').live_grep({ search_dirs = {dir} })
end

M.guy = {
	n = {
		["<leader><leader>"] = {"<cmd> Telescope resume <CR><ESC>", "Resume last telescope session"},
		["<leader>fr"] = {"<cmd> Telescope grep_string <CR><ESC>", "Find text under cursor"},
    ["<C-]>"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },
    ["<C-[>"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },
    ["<leader>h"] = {
      "<cmd>nohlsearch<CR>",
      "Clear highlights",
    },
    ["<leader>ca"] = {
      "cmd lua vim.lsp.buf.code_action()<CR>",
      "LSP code action",
    },
    ["<leader>gs"] = {
      "<cmd>Git<CR>",
      "Git status",
    },
    ["<leader>fw"] = {
      "<cmd>lua live_grep_in_nvimtree_directory()<CR>",
      "Find word in nvimtree",
    },
    ["<leader>fW"] = {
      "<cmd>lua live_grep_in_directory()<CR>",
      "Find word in nvimtree",
    },
	}
}

vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

return M
