-- nvim-fountain plugin main module
local M = {}

-- Plugin configuration with defaults
M.config = {
	-- Default configuration options
	highlight_groups = {
		-- Custom highlight groups can be defined here
	},
	keymaps = {
		-- Default keymaps
		next_scene = "]]",
		prev_scene = "[[",
		uppercase_line = "<S-CR>",
	},
	-- Export configuration
	export = {
		output_dir = nil,
		pdf = {
			options = "--overwrite",
			-- command = function(current_file, output_path, options) ... end
		},
	},
}

-- Setup function to be called by the user
function M.setup(opts)
	-- Merge user config with defaults
	opts = opts or {}
	M.config = vim.tbl_deep_extend("force", M.config, opts)

	-- Set up autocommands
	M.create_autocommands()

	-- Set up commands
	M.create_commands()

	-- Define the highlight groups (also reapplied on ColorScheme below).
	require("nvim-fountain.syntax").setup(M.config.highlight_groups)
end

-- Create plugin autocommands
function M.create_autocommands()
	local augroup = vim.api.nvim_create_augroup("nvim_fountain", { clear = true })

	-- Colourschemes may clear highlight groups, so restore ours afterwards.
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = augroup,
		callback = function()
			require("nvim-fountain.syntax").setup(M.config.highlight_groups)
		end,
	})

	-- Set up keymaps when opening a fountain file
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "fountain",
		group = augroup,
		callback = function()
			require("nvim-fountain.keymaps").setup(M.config)
		end,
	})
end

-- Create plugin commands
function M.create_commands()
	-- Create global commands
	vim.api.nvim_create_user_command("FountainStats", function()
		require("nvim-fountain.commands").show_stats()
	end, { desc = "Display screenplay statistics" })

	vim.api.nvim_create_user_command("FountainFormat", function()
		require("nvim-fountain.commands").format_document()
	end, { desc = "Format the current fountain document" })

	-- Add export commands
	vim.api.nvim_create_user_command("FountainExportPDF", function(opts)
		local output_path = opts.args ~= "" and opts.args or nil
		require("nvim-fountain.export").export_pdf(output_path)
	end, { nargs = "?", desc = "Export fountain to PDF" })
end

-- Navigate to next/previous scene heading
function M.next_section(backwards)
	local patterns = require("nvim-fountain.patterns")
	local flags = backwards and "b" or ""

	local line = vim.fn.search(patterns.scene_heading, flags)
	if line > 0 then
		vim.api.nvim_win_set_cursor(0, { line, 0 })
	end
end

return M
