local h = require("tests.harness")
local fountain = require("nvim-fountain")

local lines = {
  "INT. FIRST - DAY",
  "Some action.",
  "INT/EXT. SECOND - DAY",
  "More action.",
  "i/e THIRD - NIGHT",
  "EST. FOURTH - DAWN",
  ".ext. FORCED - EVENING",
}

h.test("next_section finds every supported heading form", function()
  fountain.setup()
  h.scratch(lines, "fountain")
  vim.api.nvim_win_set_cursor(0, { 1, 0 })

  for _, target in ipairs({ 3, 5, 6, 7 }) do
    fountain.next_section(false)
    h.eq(vim.api.nvim_win_get_cursor(0)[1], target, "forward navigation")
  end

  -- search() honours 'wrapscan', so navigation continues from the top.
  fountain.next_section(false)
  h.eq(vim.api.nvim_win_get_cursor(0)[1], 1, "forward navigation did not wrap")
end)

h.test("next_section navigation backwards", function()
  fountain.setup()
  h.scratch(lines, "fountain")
  vim.api.nvim_win_set_cursor(0, { 7, 0 })

  for _, target in ipairs({ 6, 5, 3, 1 }) do
    fountain.next_section(true)
    h.eq(vim.api.nvim_win_get_cursor(0)[1], target, "backward navigation")
  end
end)
