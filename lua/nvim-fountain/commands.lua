-- nvim-fountain commands module
local patterns = require("nvim-fountain.patterns")

local M = {}

local cue_punctuation = "'&.,!?-"

local function trim(line)
	return line:match("^%s*(.-)%s*$")
end

local function is_transition(line)
	if line:sub(1, 1) == ">" then
		return true
	end
	return line:upper():match("TO:$") ~= nil
end

-- Cues can carry extensions such as (V.O.) or (CONT'D); strip them so all
-- appearances of a character are grouped together.
local function character_name(line)
	return trim(line:gsub("%s*%([^)]*%)$", ""))
end

local function is_uppercase_cue(name)
	local has_letter = false
	for char in name:gmatch(".") do
		if char:match("%a") then
			if char:upper() ~= char then
				return false
			end
			has_letter = true
		elseif not (char:match("%d") or char:match("%s") or cue_punctuation:find(char, 1, true)) then
			return false
		end
	end
	return has_letter
end

local function is_character_cue(lines, index)
	local line = trim(lines[index])
	if line == "" or line:sub(1, 1) == "(" then
		return false
	end
	if patterns.is_scene_heading(line) or is_transition(line) then
		return false
	end

	local name = character_name(line)
	if name == "" or not is_uppercase_cue(name) then
		return false
	end

	-- A cue is immediately followed by dialogue or a parenthetical; a line
	-- ending in all caps followed by a blank line is action, not a cue.
	local following = trim(lines[index + 1] or "")
	if following == "" or patterns.is_scene_heading(following) or is_transition(following) then
		return false
	end
	return true
end

local function is_non_screenplay_line(line, in_title_page)
	if line:match("^#") or line:match("^=") or line:match("^%[") or line:match("^===") then
		return true
	end
	return in_title_page and line:match("^%w[%w ]*:") ~= nil
end

-- Calculate screenplay statistics
function M.get_stats(bufnr)
	bufnr = bufnr or 0
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local stats = {
		scenes = 0,
		characters = {},
		dialogue_lines = 0,
		action_lines = 0,
		total_lines = #lines,
	}

	-- Title page fields live in the first block, before the first blank line.
	local title_page_end = 0
	for index, line in ipairs(lines) do
		if trim(line) == "" then
			break
		end
		title_page_end = index
	end

	local index = 1
	while index <= #lines do
		local line = trim(lines[index])
		if line ~= "" then
			if patterns.is_scene_heading(line) then
				stats.scenes = stats.scenes + 1
			elseif is_character_cue(lines, index) then
				local name = character_name(line)
				stats.characters[name] = (stats.characters[name] or 0) + 1

				local j = index + 1
				while j <= #lines and trim(lines[j]) ~= "" do
					local dialogue = trim(lines[j])
					if not dialogue:match("^%([^)]*%)$") then
						stats.dialogue_lines = stats.dialogue_lines + 1
					end
					j = j + 1
				end
				-- Dialogue lines belong to this cue and must not be counted again.
				index = j - 1
			elseif is_transition(line) or is_non_screenplay_line(line, index <= title_page_end) then
				-- Transitions, headers, synopses and title page fields are not action.
			else
				stats.action_lines = stats.action_lines + 1
			end
		end
		index = index + 1
	end

	stats.unique_characters = 0
	for _ in pairs(stats.characters) do
		stats.unique_characters = stats.unique_characters + 1
	end

	return stats
end

-- Display screenplay statistics in a reusable split.
function M.show_stats()
	if M._stats_source and not vim.api.nvim_buf_is_valid(M._stats_source) then
		M._stats_source = nil
	end

	local current = vim.api.nvim_get_current_buf()
	local source = current
	if M._stats_buf and current == M._stats_buf and M._stats_source then
		source = M._stats_source
	else
		M._stats_source = current
	end

	local stats = M.get_stats(source)
	local lines = {
		"# Fountain Screenplay Statistics",
		"",
		"- Total scenes: " .. stats.scenes,
		"- Unique characters: " .. stats.unique_characters,
		"- Dialogue lines: " .. stats.dialogue_lines,
		"- Action lines: " .. stats.action_lines,
		"- Total lines: " .. stats.total_lines,
		"",
		"## Character Appearances",
		"",
	}

	local sorted_chars = {}
	for name, count in pairs(stats.characters) do
		table.insert(sorted_chars, { name = name, count = count })
	end
	table.sort(sorted_chars, function(a, b)
		return a.count > b.count
	end)
	for _, char in ipairs(sorted_chars) do
		table.insert(lines, "- " .. char.name .. ": " .. char.count)
	end

	local buf = M._stats_buf
	local win = nil
	if buf and vim.api.nvim_buf_is_valid(buf) then
		win = vim.fn.bufwinid(buf)
	else
		buf = vim.api.nvim_create_buf(false, true)
		M._stats_buf = buf
		vim.bo[buf].bufhidden = "wipe"
		vim.bo[buf].filetype = "markdown"
	end

	if win and win ~= -1 then
		vim.api.nvim_set_current_win(win)
	else
		vim.cmd("vsplit")
		vim.api.nvim_win_set_buf(0, buf)
	end

	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
end

-- Normalise whitespace without changing the structure of the screenplay.
-- Returns the number of lines that were changed.
function M.format_document(bufnr)
	bufnr = bufnr or 0
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local formatted = {}
	local changes = 0
	local blank_run = 0

	for _, raw in ipairs(lines) do
		local line = raw:gsub("%s+$", "")
		if line ~= raw then
			changes = changes + 1
		end

		if line == "" then
			blank_run = blank_run + 1
			if blank_run <= 1 then
				table.insert(formatted, line)
			else
				changes = changes + 1
			end
		else
			blank_run = 0
			table.insert(formatted, line)
		end
	end

	-- A single trailing blank line is enough.
	if formatted[#formatted] == "" then
		table.remove(formatted)
		changes = changes + 1
	end

	if changes > 0 then
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
	end
	vim.notify(string.format("Fountain: formatted %d line(s)", changes), vim.log.levels.INFO)
	return changes
end

return M
