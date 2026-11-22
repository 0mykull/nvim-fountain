-- Shared Fountain patterns, used by navigation and statistics so both agree
-- on what counts as a scene heading.
local M = {}

-- Very magic, case-insensitive. Accepts INT., EXT., INT/EXT., I/E. and EST.
-- headings, with or without a leading forced marker (.) and with either a
-- dot, whitespace or end-of-line after the prefix.
M.scene_heading = [[\v^\s*\.?\s*\c(INT|EXT|INT/EXT|I/E|EST)(\.|\s|$)]]

local scene_regex = vim.regex(M.scene_heading)

function M.is_scene_heading(line)
  return scene_regex:match_str(line) ~= nil
end

return M
