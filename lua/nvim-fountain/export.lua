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
	local cmd = string.format('afterwriting --source "%s" --pdf "%s"', current_file, output_path)

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

-- Preview in browser - direct system call approach
function M.preview()
	local current_file = vim.fn.expand("%:p")
	local temp_html = vim.fn.tempname() .. ".html"

	-- Save current buffer
	vim.cmd("write")

	-- Build the command - exactly like the working CLI command
	local cmd = string.format('afterwriting --source "%s" --pdf "%s" --overwrite', current_file, temp_html)

	vim.notify("Running: " .. cmd, vim.log.levels.INFO)

	-- Use system() instead of jobstart for direct execution
	local result = vim.fn.system(cmd)

	if vim.v.shell_error == 0 then
		-- Open in browser
		local open_cmd
		if vim.fn.has("mac") == 1 then
			open_cmd = "open"
		elseif vim.fn.has("unix") == 1 then
			open_cmd = "xdg-open"
		elseif vim.fn.has("win32") == 1 then
			open_cmd = "start"
		end

		if open_cmd then
			vim.fn.system(string.format('%s "%s"', open_cmd, temp_html))
			vim.notify("Preview opened in browser", vim.log.levels.INFO)
		else
			vim.notify("Could not determine how to open the browser", vim.log.levels.ERROR)
		end
	else
		vim.notify("Preview generation failed: " .. result, vim.log.levels.ERROR)
	end
end

return M
