return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		options = {
			mode = "buffers",
			numbers = "none",
			diagnostics = "nvim_lsp",
			diagnostics_update_in_insert = false,
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer",
					text_align = "left",
					separator = true,
				},
			},
			show_buffer_close_icons = false,
			show_close_icon = false,
			separator_style = "thin",
			always_show_bufferline = true,
			enforce_regular_tabs = true,
			highlights = {
				separator = {
					fg = "#1a1b26",
					bg = "NONE",
				},
				separator_selected = {
					fg = "#1a1b26",
					bg = "NONE",
				},
				background = {
					fg = "#565f89",
					bg = "NONE",
				},
				buffer_selected = {
					fg = "#c0caf5",
					bg = "NONE",
					bold = true,
					italic = false,
				},
				diagnostic_selected = {
					fg = "#f7768e",
					bold = true,
				},
				modified = {
					fg = "#e0af68",
				},
				modified_selected = {
					fg = "#e0af68",
				},
				indicator_selected = {
					fg = "#89b4fa",
					bg = "NONE",
				},
			},
		},
	},
}
