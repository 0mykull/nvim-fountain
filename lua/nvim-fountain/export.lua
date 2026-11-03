-- nvim-fountain export module
local M = {}

-- Default export configuration
local default_config = {
	output_dir = nil,
	pdf = {
		options = "--overwrite",
		-- Builds the command (as a list, for vim.fn.system) used to export.
		-- Override this to use a different program (e.g. screenplain) with
		-- its own argument layout.
		command = function(current_file, output_path, options)
			local cmd = { "afterwriting", "--source", current_file, "--pdf", output_path }

			if options and options ~= "" then
				for option in string.gmatch(options, "%S+") do
					table.insert(cmd, option)
				end
			end

			return cmd
		end,
	},
}

-- Get export configuration
local function get_config()
	local config = require("nvim-fountain").config.export or {}
	return vim.tbl_deep_extend("force", default_config, config)
end

-- Export to PDF using afterwriting - direct system call approach
function M.export_pdf(output_path)
	local config = get_config()
	local current_file = vim.fn.expand("%:p")

	-- Determine output path
	if not output_path then
		if config.output_dir then
			local filename = vim.fn.fnamemodify(current_file, ":t:r") .. ".pdf"
			output_path = config.output_dir .. "/" .. filename
		else
			output_path = vim.fn.expand("%:p:r") .. ".pdf"
		end
	end

	-- Save current buffer
	vim.cmd("write")

	-- Build the command (overridable via config.export.pdf.command)
	local cmd = config.pdf.command(current_file, output_path, config.pdf.options)

	vim.notify("Running: " .. table.concat(cmd, " "), vim.log.levels.INFO)

	-- Use system() instead of jobstart for direct execution
	local result = vim.fn.system(cmd)

	if vim.v.shell_error == 0 then
		vim.notify("Successfully exported to " .. output_path, vim.log.levels.INFO)
	else
		vim.notify("Export failed: " .. result, vim.log.levels.ERROR)
	end
end

return M
