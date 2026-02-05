vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function(ev)
    local commit_buf = ev.buf

    -- Skip floating windows and scratch buffers (e.g., copilot-commit-message picker)
    local win = vim.fn.bufwinid(commit_buf)
    if win ~= -1 then
      local win_config = vim.api.nvim_win_get_config(win)
      if win_config.relative ~= "" then
        return
      end
    end
    if vim.bo[commit_buf].buftype == "nofile" then
      return
    end

    local diff_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[diff_buf].bufhidden = "wipe"
    vim.bo[diff_buf].filetype = "diff"

    vim.fn.jobstart({ "git", "diff", "--cached", "--stat", "-p" }, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data and vim.api.nvim_buf_is_valid(diff_buf) then
          vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, data)
        end
      end,
    })

    vim.cmd("rightbelow vsplit")
    local diff_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(diff_win, diff_buf)
    vim.cmd("wincmd p")

    vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
      buffer = commit_buf,
      once = true,
      callback = function()
        if vim.api.nvim_win_is_valid(diff_win) then
          vim.api.nvim_win_close(diff_win, true)
        end
      end,
    })
  end,
  desc = "show diff in split when editing commit message",
})
