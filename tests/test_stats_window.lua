local h = require("tests.harness")
local commands = require("nvim-fountain.commands")

h.test("show_stats reuses its window and refreshes content", function()
  require("nvim-fountain").setup()
  local source = h.scratch({ "INT. FIRST - DAY", "", "JOHN", "Hello." }, "fountain")

  commands.show_stats()
  local stats_buf = vim.api.nvim_get_current_buf()
  local stats_win = vim.api.nvim_get_current_win()
  h.eq(vim.bo[stats_buf].filetype, "markdown")
  h.eq(vim.bo[stats_buf].modifiable, false)
  h.contains(
    table.concat(vim.api.nvim_buf_get_lines(stats_buf, 0, -1, false), "\n"),
    "Total scenes: 1"
  )

  vim.api.nvim_buf_set_lines(source, -1, -1, false, { "", "EXT. SECOND - NIGHT" })
  commands.show_stats()

  h.eq(vim.api.nvim_get_current_buf(), stats_buf, "created a second stats buffer")
  h.eq(vim.api.nvim_get_current_win(), stats_win, "created a second stats window")
  h.contains(
    table.concat(vim.api.nvim_buf_get_lines(stats_buf, 0, -1, false), "\n"),
    "Total scenes: 2"
  )
end)
