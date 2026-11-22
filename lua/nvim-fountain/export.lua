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

local function ensure_parent_dir(path)
	local parent = vim.fn.fnamemodify(path, ":h")
	if parent ~= "" and vim.fn.isdirectory(parent) == 0 then
		vim.fn.mkdir(parent, "p")
	end
end

-- Export to PDF (afterwriting by default, overridable through configuration)
function M.export_pdf(output_path)
	local config = get_config()
	local current_file = vim.api.nvim_buf_get_name(0)

	if current_file == "" then
		vim.notify("Fountain: export requires a saved file", vim.log.levels.ERROR)
		return false
	end
	if type(config.pdf.command) ~= "function" then
		vim.notify("Fountain: export.pdf.command must be a function", vim.log.levels.ERROR)
		return false
	end

	-- Determine output path, expanding ~ and environment variables.
	if output_path then
		output_path = vim.fn.expand(output_path)
	else
		local filename = vim.fn.fnamemodify(current_file, ":t:r") .. ".pdf"
		if config.output_dir then
			local dir = vim.fn.expand(config.output_dir)
			output_path = dir .. "/" .. filename
		else
			output_path = vim.fn.fnamemodify(current_file, ":p:r") .. ".pdf"
		end
	end
	ensure_parent_dir(output_path)

	if vim.bo.modified then
		vim.cmd("write")
	end

	local ok, cmd = pcall(config.pdf.command, current_file, output_path, config.pdf.options)
	if not ok or type(cmd) ~= "table" or #cmd == 0 then
		vim.notify("Fountain: export.pdf.command must return a command list", vim.log.levels.ERROR)
		return false
	end

	vim.notify("Running: " .. table.concat(cmd, " "), vim.log.levels.INFO)

	local result = vim.fn.system(cmd)
	if vim.v.shell_error == 0 then
		vim.notify("Successfully exported to " .. output_path, vim.log.levels.INFO)
		return true
	end

	vim.notify("Export failed: " .. result, vim.log.levels.ERROR)
	return false
end

return M
