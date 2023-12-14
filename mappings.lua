local M = {}
M.guy = {
	n = {
		["<leader><leader>"] = {"<cmd> Telescope resume <CR><ESC>", "Resume last telescope session"},
		["<leader>fr"] = {"<cmd> Telescope grep_string <CR><ESC>", "Find text under cursor"},
	}
}
return M
