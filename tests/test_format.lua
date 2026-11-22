local h = require("tests.harness")
local commands = require("nvim-fountain.commands")

h.test("format_document trims trailing whitespace and collapses blank runs", function()
  local buf = h.scratch({
    "INT. ROOM - DAY   ",
    "",
    "",
    "",
    "Action line.   ",
    "",
    "JOHN",
    "Hello.  ",
  }, "fountain")

  local changes = commands.format_document(buf)
  h.ok(changes > 0, "format_document reported no changes")

  local expected = { "INT. ROOM - DAY", "", "Action line.", "", "JOHN", "Hello." }
  h.eq(vim.inspect(vim.api.nvim_buf_get_lines(buf, 0, -1, false)), vim.inspect(expected))
end)

h.test("format_document is idempotent", function()
  local buf = h.scratch({ "INT. ROOM - DAY", "", "Action." }, "fountain")
  h.eq(commands.format_document(buf), 0, "clean document was modified")
end)

h.test("FountainFormat has no buffer-local shadow", function()
  require("nvim-fountain").setup()
  vim.cmd("edit " .. vim.env.NVIM_FOUNTAIN_ROOT .. "/examples/template.fountain")

  local buffer_commands = vim.api.nvim_buf_get_commands(0, {})
  h.eq(buffer_commands.FountainFormat, nil, "buffer-local FountainFormat shadows global command")
end)
