local h = require("tests.harness")
local root = vim.env.NVIM_FOUNTAIN_ROOT

h.test("READMEs only describe implemented features", function()
  for _, name in ipairs({ "README.md", "README.zh-CN.md" }) do
    local content = table.concat(vim.fn.readfile(root .. "/" .. name), "\n")
    h.ok(not content:find("Export to PDF, HTML", 1, true), name .. " still claims HTML export")
    h.ok(not content:find("use_treesitter", 1, true), name .. " still documents treesitter")
    h.ok(not content:find("COMMIT_MESSAGE.md", 1, true), name .. " has a broken example link")
  end
end)

h.test("documented example configs use only supported options", function()
  for _, name in ipairs({ "examples/lazyvim_config.lua", "examples/standalone_config.lua" }) do
    local content = table.concat(vim.fn.readfile(root .. "/" .. name), "\n")
    h.ok(not content:find("use_treesitter", 1, true), name .. " still sets use_treesitter")
  end
end)
