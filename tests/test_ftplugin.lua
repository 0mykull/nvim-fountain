local h = require("tests.harness")

local function mappings_for(lhs)
  local found = {}
  for _, mapping in ipairs(vim.fn.maplist()) do
    if mapping.lhs == lhs then
      table.insert(found, mapping)
    end
  end
  return found
end

h.test("fountain ftplugin keeps <S-CR> buffer-local", function()
  require("nvim-fountain").setup()
  vim.cmd("edit " .. vim.env.NVIM_FOUNTAIN_ROOT .. "/examples/template.fountain")
  h.eq(vim.bo.filetype, "fountain")

  local global = vim.tbl_filter(function(m)
    return m.buffer == 0
  end, mappings_for("<S-CR>"))
  h.eq(#global, 0, "unexpected global <S-CR> mapping")

  local buffer_local = vim.tbl_filter(function(m)
    return m.buffer ~= 0
  end, mappings_for("<S-CR>"))
  h.ok(#buffer_local >= 1, "missing buffer-local <S-CR> mapping")

  vim.cmd("enew!")
  h.eq(#mappings_for("<S-CR>"), 0, "<S-CR> mapping leaked into an unrelated buffer")
end)
