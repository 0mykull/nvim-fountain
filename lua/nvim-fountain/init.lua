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
	-- Enable treesitter integration if available
	use_treesitter = true,
	-- Export configuration
	export = {
		output_dir = nil,
		pdf = {
			options = "--overwrite",
		},
	},
	-- Statistics settings
	statistics = {
		count_scenes = true,
		count_characters = true,
		count_dialogue = true,
		count_action = true,
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

	-- Set up syntax highlighting if not using treesitter
	if not M.config.use_treesitter then
		require("nvim-fountain.syntax").setup()
	end
end

-- Create plugin autocommands
function M.create_autocommands()
	local augroup = vim.api.nvim_create_augroup("nvim_fountain", { clear = true })

	-- File detection
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = "*.fountain",
		group = augroup,
		callback = function()
			vim.bo.filetype = "fountain"
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
	-- More comprehensive pattern to match scene headings
	-- This pattern matches all valid Fountain scene heading formats
	local pattern = "^\\s*\\([\\.]\\s*\\)\\?\\(INT\\|EXT\\|EST\\|INT\\/EXT\\|I\\/E\\)[\\. ]"
	local flags = backwards and "b" or ""

	local line = vim.fn.search(pattern, flags)
	if line > 0 then
		vim.api.nvim_win_set_cursor(0, { line, 0 })
	end
end

return M
