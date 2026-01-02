-- nvim-fountain export module
local M = {}

-- Default export configuration
local default_config = {
	output_dir = nil,
	pdf = {
		options = "--overwrite",
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

	-- Build the command - exactly like the working CLI command
	local cmd = { "afterwriting", "--source", current_file, "--pdf", output_path }

	-- Add any additional options
	if config.pdf.options and config.pdf.options ~= "" then
		cmd = cmd .. " " .. config.pdf.options
	end

	vim.notify("Running: " .. cmd, vim.log.levels.INFO)

	-- Use system() instead of jobstart for direct execution
	local result = vim.fn.system(cmd)

	if vim.v.shell_error == 0 then
		vim.notify("Successfully exported to " .. output_path, vim.log.levels.INFO)
	else
		vim.notify("Export failed: " .. result, vim.log.levels.ERROR)
	end
end

return M
