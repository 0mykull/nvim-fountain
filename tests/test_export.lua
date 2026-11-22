local h = require("tests.harness")
local fountain = require("nvim-fountain")
local export = require("nvim-fountain.export")

h.test("export_pdf expands ~ and creates the output directory", function()
  local dir = "~/nvim-fountain-test-" .. vim.fn.getpid()
  local captured

  fountain.setup({
    export = {
      output_dir = dir,
      pdf = {
        command = function(current_file, output_path, options)
          captured = { file = current_file, path = output_path, options = options }
          return { "true" }
        end,
      },
    },
  })

  local source = vim.fn.tempname() .. ".fountain"
  vim.fn.writefile({ "INT. ROOM - DAY", "", "JOHN", "Hello." }, source)
  vim.cmd("edit " .. source)

  h.eq(export.export_pdf(), true, "export failed")

  local expanded = vim.fn.expand(dir)
  h.eq(vim.fn.isdirectory(expanded), 1, "output directory was not created")
  h.eq(
    captured.path,
    expanded .. "/" .. vim.fn.fnamemodify(source, ":t:r") .. ".pdf",
    "unexpected output path"
  )
  h.eq(
    vim.fn.fnamemodify(captured.file, ":t"),
    vim.fn.fnamemodify(source, ":t"),
    "unexpected source path"
  )
  h.eq(captured.options, "--overwrite", "unexpected options")

  vim.fn.delete(expanded, "rf")
  vim.fn.delete(source)
end)

h.test("export_pdf rejects an unnamed buffer", function()
  fountain.setup({
    export = {
      output_dir = nil,
      pdf = {
        command = function()
          error("command should not have been called")
        end,
      },
    },
  })

  h.scratch({ "INT. ROOM - DAY" }, "fountain")
  h.eq(vim.api.nvim_buf_get_name(0), "", "expected an unnamed buffer")
  h.eq(export.export_pdf(), false, "export should fail for an unnamed buffer")
end)
