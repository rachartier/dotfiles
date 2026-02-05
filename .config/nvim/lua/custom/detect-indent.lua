local exclude_ft = { netrw = true, lazy = true, mason = true }
local exclude_bt = { help = true, terminal = true, nofile = true }

local function guess_indent(bufnr)
  bufnr = bufnr or 0

  if exclude_ft[vim.bo[bufnr].filetype] or exclude_bt[vim.bo[bufnr].buftype] then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, math.min(256, vim.api.nvim_buf_line_count(bufnr)), false)

  local tab_count = 0
  local space_counts = {}
  local prev_indent = 0

  for _, line in ipairs(lines) do
    if line:match("^%s*$") then
      goto continue
    end

    local leading = line:match("^(%s*)")
    if leading:match("^\t") then
      tab_count = tab_count + 1
    elseif leading:match("^ ") then
      local spaces = #leading
      local diff = math.abs(spaces - prev_indent)
      if diff > 0 and diff <= 8 then
        space_counts[diff] = (space_counts[diff] or 0) + 1
      end
      prev_indent = spaces
    end

    ::continue::
  end

  local space_total = 0
  local best_width, best_count = 4, 0
  for width, count in pairs(space_counts) do
    space_total = space_total + count
    if count > best_count then
      best_width, best_count = width, count
    end
  end

  if tab_count > space_total then
    vim.bo[bufnr].expandtab = false
    vim.bo[bufnr].shiftwidth = 0
    vim.bo[bufnr].tabstop = 4
  elseif space_total > 0 then
    vim.bo[bufnr].expandtab = true
    vim.bo[bufnr].shiftwidth = best_width
    vim.bo[bufnr].tabstop = best_width
  end
end

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(ev)
    guess_indent(ev.buf)
  end,
  desc = "guess indentation from buffer content",
})
