---@type ChadrcConfig
local M = {}
M.ui = { theme = "onedark" }
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

vim.opt.relativenumber = true
vim.o.scrolloff = 2

-- Configure copy paste to use system clipboard
local function copy(lines, _)
  require("osc52").copy(table.concat(lines, "\n"))
end

local function paste()
  return { vim.fn.split(vim.fn.getreg "", "\n"), vim.fn.getregtype "" }
end

vim.g.clipboard = {
  name = "osc52",
  copy = { ["+"] = copy, ["*"] = copy },
  paste = { ["+"] = paste, ["*"] = paste },
}

-- When vim opens, use the directory given as an argument
local function open_nvim_tree(data)
  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.toggle {
    path = nil,
    current_window = false,
    find_file = false,
    update_root = false,
    focus = true,
  }
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- Make double click select whole words including - and .
-- vim.opt.iskeyword:append("-")
-- vim.opt.iskeyword:append(".")

vim.g.copilot_assume_mapped = true

-- Disable tab for cmp since it is used for copilot
local present, cmp = pcall(require, "cmp")
if present then
  local function no_action(fallback)
    fallback()
  end
  cmp.setup {
    mapping = {
      ["<Tab>"] = no_action,
      ["<S-Tab>"] = no_action,
      ["<Down>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
      ["<Up>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    },
  }
end

vim.cmd [[command! W write]]

local function adjustNvimTreeWidth()
  -- Get the total number of windows
  local win_count = #vim.api.nvim_list_wins()

  -- check if nvimtree is the only window open
  if win_count == 2 then
    -- iterate over all windows to find the nvimtree window
    for _, win_id in pairs(vim.api.nvim_list_wins()) do
      local buf_id = vim.api.nvim_win_get_buf(win_id)
      local ft = vim.api.nvim_buf_get_option(buf_id, "filetype")

      -- Check if the filetype of the buffer is NvimTree
      if ft == "NvimTree" then
        -- Set the width of the NvimTree window
        vim.api.nvim_win_set_width(win_id, 30)
        break
      end
    end
  end
end
vim.api.nvim_create_autocmd("WinNew", {
  pattern = "*",
  callback = adjustNvimTreeWidth,
})

local mru_file = vim.fn.stdpath "data" .. "/mru_projects.txt"

-- Function to read MRU projects from a file
local function read_mru_projects()
  local projects = {}
  local file = io.open(mru_file, "r")
  if file then
    for line in file:lines() do
      table.insert(projects, { name = line, path = line })
    end
    file:close()
  end
  return projects
end

-- Function to update the MRU projects list
local function update_mru_projects(project_path)
  local projects = read_mru_projects()
  -- Remove project if it already exists in the list
  for i, project in ipairs(projects) do
    if project.path == project_path then
      table.remove(projects, i)
      break
    end
  end
  -- Insert project at the top of the list
  table.insert(projects, 1, { name = project_path, path = project_path })

  -- Write updated list back to file
  local file = io.open(mru_file, "w")
  if file then
    for _, project in ipairs(projects) do
      file:write(project.path .. "\n")
    end
    file:close()
  end
end

-- Function to be called when selecting a project
local function on_project_selected(selection)
  update_mru_projects(selection.value.path)
  vim.cmd("cd " .. selection.value.path)
end

-- Modified project picker function
local function project_picker()
  local projects = read_mru_projects()
  local finders = require "telescope.finders"
  local pickers = require "telescope.pickers"
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local conf = require("telescope.config").values

  pickers
    .new({}, {
      prompt_title = "Select a Project",
      finder = finders.new_table {
        results = projects,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      },
      sorter = conf.generic_sorter {},
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          -- Change directory to the selected project
          on_project_selected(selection)
        end)
        return true
      end,
    })
    :find()
end

-- On startup, add the current directory or file to the MRU list
local current_path = vim.fn.getcwd()
update_mru_projects(current_path)

-- Command to invoke the picker
vim.api.nvim_create_user_command("Projects", project_picker, {})
M.ui.lsp_semantic_tokens = true
M.ui.tabufline = {
  enabled = false
}

return M
