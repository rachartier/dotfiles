function _G._python_indent()
  local lnum = vim.v.lnum
  local ind = vim.fn["python#GetIndent"](lnum)

  -- walk up past blank lines and use the nearest non-blank line's indent.
  if ind <= 0 and lnum > 1 and vim.fn.getline(lnum - 1):match("^%s*$") then
    local prev = lnum - 1
    while prev > 0 and vim.fn.getline(prev):match("^%s*$") do
      prev = prev - 1
    end
    if prev > 0 then
      return vim.fn.indent(prev)
    end
  end

  return ind
end

vim.bo.indentexpr = "v:lua._python_indent()"
