local M = {}
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
	}
}
M.disabled = {
  n = {
    ["<tab>"] = ""
  },
}
return M
