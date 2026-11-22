-- Minimal headless test harness for nvim-fountain.
local M = {}

M.passed = 0
M.failed = 0

function M.test(name, fn)
  local ok, err = pcall(fn)
  if ok then
    M.passed = M.passed + 1
    print("ok   " .. name)
  else
    M.failed = M.failed + 1
    print("FAIL " .. name .. "\n     " .. tostring(err))
  end
end

function M.ok(condition, message)
  if not condition then
    error(message or "assertion failed", 2)
  end
end

function M.eq(actual, expected, message)
  if actual ~= expected then
    error(
      (message or "values differ")
        .. ": expected "
        .. vim.inspect(expected)
        .. ", got "
        .. vim.inspect(actual),
      2
    )
  end
end

function M.contains(haystack, needle, message)
  if not haystack or not haystack:find(needle, 1, true) then
    error((message or "missing substring") .. ": " .. tostring(needle), 2)
  end
end

-- Replace the current buffer with a scratch buffer, optionally filled with lines.
function M.scratch(lines, filetype)
  vim.cmd("enew!")
  local buf = vim.api.nvim_get_current_buf()
  if lines then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  end
  if filetype then
    vim.bo[buf].filetype = filetype
  end
  return buf
end

function M.load(root)
  local files = vim.fn.glob(root .. "/tests/test_*.lua", true, true)
  table.sort(files)
  for _, file in ipairs(files) do
    dofile(file)
  end
end

function M.finish()
  print(string.format("\n%d passed, %d failed", M.passed, M.failed))
  if M.failed > 0 then
    vim.cmd("cq " .. math.min(M.failed, 255))
  else
    vim.cmd("qa!")
  end
end

return M
