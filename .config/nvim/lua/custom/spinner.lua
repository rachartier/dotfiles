local M = {}

local characters = { "-", "\\", "|", "/" }

--- Creates a spinner showing `text` as virtual text.
--- `line` is a function returning the 1-indexed line to draw on.
function M.new(text, line)
  local spinner = {
    ns_id = vim.api.nvim_create_namespace("spinner_" .. text),
    timer = nil,
    index = 1,
  }

  function spinner.start()
    if spinner.timer then
      return
    end
    spinner.timer = assert(vim.uv.new_timer())
    spinner.timer:start(0, 80, function()
      vim.schedule(function()
        if not spinner.timer then
          return
        end
        spinner.index = (spinner.index % #characters) + 1
        vim.api.nvim_buf_clear_namespace(0, spinner.ns_id, 0, -1)
        vim.api.nvim_buf_set_extmark(0, spinner.ns_id, line() - 1, 0, {
          virt_text = { { " " .. characters[spinner.index] .. " " .. text, "Comment" } },
          virt_text_pos = "overlay",
        })
      end)
    end)
  end

  function spinner.stop()
    if not spinner.timer then
      return
    end
    spinner.timer:stop()
    spinner.timer:close()
    spinner.timer = nil
    vim.schedule(function()
      vim.api.nvim_buf_clear_namespace(0, spinner.ns_id, 0, -1)
    end)
  end

  return spinner
end

return M
