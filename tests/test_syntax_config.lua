local h = require("tests.harness")
local root = vim.env.NVIM_FOUNTAIN_ROOT
local fountain = require("nvim-fountain")

h.test("user highlight groups are applied and survive syntax loading", function()
  fountain.setup({
    highlight_groups = {
      FountainSceneHeading = { link = "ErrorMsg" },
    },
  })

  h.eq(
    vim.api.nvim_get_hl(0, { name = "FountainSceneHeading" }).link,
    "ErrorMsg",
    "custom highlight group was not applied"
  )

  vim.cmd("edit " .. root .. "/examples/template.fountain")
  h.eq(vim.bo.filetype, "fountain")
  h.eq(
    vim.api.nvim_get_hl(0, { name = "FountainSceneHeading" }).link,
    "ErrorMsg",
    "custom highlight group was overwritten by the syntax file"
  )
end)

h.test("highlight groups are reapplied after a colorscheme change", function()
  fountain.setup({
    highlight_groups = {
      FountainSceneHeading = { link = "WarningMsg" },
    },
  })
  vim.cmd("colorscheme default")
  h.eq(
    vim.api.nvim_get_hl(0, { name = "FountainSceneHeading" }).link,
    "WarningMsg",
    "custom highlight group was lost on ColorScheme"
  )

  fountain.setup({ highlight_groups = { FountainSceneHeading = { link = "Title" } } })
  h.eq(
    vim.api.nvim_get_hl(0, { name = "FountainSceneHeading" }).link,
    "Title",
    "default highlight group was not restored"
  )
end)

h.test("duplicate and unused legacy files are gone", function()
  local removed = {
    "after/syntax/fountain.vim",
    "ftdetect/fountain.vim",
    "ftplugin/fountain.vim",
    "plugin/fountain.lua",
    "lua/nvim-fountain/treesitter.lua",
  }
  for _, relative in ipairs(removed) do
    h.eq(vim.fn.filereadable(root .. "/" .. relative), 0, relative .. " still exists")
  end
end)
