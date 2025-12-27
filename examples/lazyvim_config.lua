-- LazyVim configuration for nvim-fountain
-- Save this file to: ~/.config/nvim/lua/plugins/fountain.lua

return {
	"0mykull/nvim-fountain",
	ft = "fountain", -- Lazy-load only for fountain files
	dependencies = {
		-- Optional dependencies
		"nvim-treesitter/nvim-treesitter", -- For enhanced syntax highlighting (future feature)
	},
	config = function()
		require("nvim-fountain").setup({
			-- Keyboard mappings (these are fully implemented)
			keymaps = {
				-- Navigation between scene headings
				next_scene = "]]",
				prev_scene = "[[",

				-- Make line uppercase and move to next line
				uppercase_line = "<S-CR>",
			},

			-- Export settings (these are fully implemented)
			export = {
				-- Default export directory (nil means same as source file)
				output_dir = nil,

				-- PDF export options
				pdf = {
					-- Options passed to afterwriting
					options = "--overwrite",
				},
			},

			-- Enable treesitter integration if available
			-- Note: Full treesitter grammar for Fountain is planned for future versions
			use_treesitter = true,
		})
	end,
}
