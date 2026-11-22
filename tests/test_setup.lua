local h = require("tests.harness")

h.test("setup registers all user commands", function()
  require("nvim-fountain").setup()

  h.eq(vim.fn.exists(":FountainStats"), 2)
  h.eq(vim.fn.exists(":FountainFormat"), 2)
  h.eq(vim.fn.exists(":FountainExportPDF"), 2)
end)

h.test("setup can be called repeatedly", function()
  local fountain = require("nvim-fountain")
  fountain.setup()
  fountain.setup({ keymaps = { next_scene = "gn" } })

  h.eq(fountain.config.keymaps.next_scene, "gn")
end)
