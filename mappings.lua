local M = {}
function live_grep_in_nvimtree_directory()
  local nvim_tree_bufnr = vim.fn.bufnr "NvimTree_1"
  local current_bufnr = vim.api.nvim_get_current_buf()
  if current_bufnr == nvim_tree_bufnr then
    -- Get the path of the selected item in NvimTree
    local lib = require "nvim-tree.lib"
    local node = lib.get_node_at_cursor()
    local path = node.absolute_path

    -- Check if the path is a directory
    if node and node.absolute_path and vim.fn.isdirectory(node.absolute_path) == 1 then
      require("telescope.builtin").live_grep { search_dirs = { path } }
    else
      require("telescope.builtin").live_grep { search_dirs = { path } }
    end
  else
    require("telescope.builtin").live_grep { search_dirs = { path } }
  end
end

function LiveGrepInDirectory()
  local input_opts = {
    prompt = "Enter Directory To Grep In: ",
    default = "",
    completion = "dir",
  }

  -- Ask for the directory
  local dir = vim.fn.input(input_opts)

  -- Run Telescope live_grep in the specified directory
  require("telescope.builtin").live_grep { search_dirs = { dir } }
end

function CustomDoubleClick()
  -- Save the current iskeyword value
  local original_iskeyword = vim.bo.iskeyword

  -- Add hyphen and dot to iskeyword
  vim.bo.iskeyword = vim.bo.iskeyword .. ",-"
  if vim.bo.filetype == "terminal" then
    vim.bo.iskeyword = vim.bo.iskeyword .. ",.,/"
  end

  -- Wait a tiny bit for iskeyword to update
  vim.defer_fn(function()
    -- Simulate word selection with the mouse
    vim.cmd "normal! bve"

    -- Restore the original iskeyword
    vim.bo.iskeyword = original_iskeyword
  end, 10)
end

M.guy = {
  n = {
    ["<2-LeftMouse>"] = {
      ":lua CustomDoubleClick()<CR>",
      "Select hyphenated word",
    },
    ["<leader><leader>"] = { "<cmd> Telescope resume <CR><ESC>", "Resume last telescope session" },
    ["<leader>fr"] = { "<cmd> Telescope grep_string <CR><ESC>", "Find text under cursor" },
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
    ["<leader>ca"] = {
      "cmd lua vim.lsp.buf.code_action()<CR>",
      "LSP code action",
    },
    ["<leader>gs"] = {
      "<cmd>Git<CR>",
      "Git status",
    },
    -- ["<leader>fw"] = {
    --   "<cmd>lua live_grep_in_nvimtree_directory()<CR>",
    --   "Find word in nvimtree",
    -- },
    ["<leader>fW"] = {
      "<cmd>lua LiveGrepInDirectory()<CR>",
      "Find word in nvimtree",
    },
    ["<C-p>"] = {
      "<cmd>Projects<CR>",
      "Find command",
    },
    ["<leader>fm"] = {
      "<cmd>Neoformat<CR>",
      "Format",
    },
    ["<leader>tt"] = {
      "<cmd>Telescope<CR>",
      "Telescope",
    },
    ["<C-j>"] = {
      "2<C-e>",
      "Scroll down",
    },
    ["<C-k>"] = {
      "2<C-y>",
      "Scroll up",
    }
  },
}

M.disabled = {
  n = {
    -- cycle through buffers
    ["<tab>"] = "",

    ["<S-tab>"] = "",
  },
}

-- Move lines using Alt-j/k.
vim.api.nvim_set_keymap("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Map C-w to work also in terminal mode
vim.api.nvim_set_keymap("t", "<C-w>", "<C-\\><C-n><C-w>", { noremap = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "v", "<Leader>fm", ":EasyAlign*<Bar><CR>", { noremap = true, silent = true })
  end,
})
vim.keymap.set("n", "<C-i>", function()
  require("whatthejump").show_jumps(true)
  return "<C-i>"
end, { expr = true, desc = "show jumps" })

return M
