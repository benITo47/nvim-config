return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local toggleterm = require("toggleterm")

		toggleterm.setup({
			size = 20,
			open_mapping = [[<c-\>]],
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = true,
			shading_factor = 2,
			start_in_insert = true,
			insert_mappings = true,
			persist_size = true,
			direction = "horizontal",
			close_on_exit = false,
			shell = vim.o.shell,
			float_opts = {
				border = "rounded",
				winblend = 0,
				highlights = {
					border = "Normal",
					background = "Normal",
				},
			},
		})

		-- helper function
		local Terminal = require("toggleterm.terminal").Terminal

		-- horizontal
		local horiz_term = Terminal:new({ direction = "horizontal" })
		vim.keymap.set({ "n", "t" }, "<leader>th", function()
			horiz_term:toggle()
		end, { desc = "Toggle horizontal terminal" })

		-- vertical
		local vert_term = Terminal:new({ direction = "vertical" })
		vim.keymap.set({ "n", "t" }, "<leader>tv", function()
			vert_term:toggle()
		end, { desc = "Toggle vertical terminal" })

		-- floating
		local float_term = Terminal:new({ direction = "float" })
		vim.keymap.set({ "n", "t" }, "<M-f>", function()
			float_term:toggle()
		end, { desc = "Toggle floating terminal" })

		-- tab
		local tab_term = Terminal:new({ direction = "tab" })
		vim.keymap.set({ "n", "t" }, "<leader>tt", function()
			tab_term:toggle()
		end, { desc = "Toggle terminal in new tab" })

		-- exit terminal mode with Esc or jk
		vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
		vim.keymap.set("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
	end,
}
