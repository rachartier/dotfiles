vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    local diff_buf = vim.api.nvim_create_buf(false, true)
    vim.bo[diff_buf].bufhidden = "wipe"
    vim.bo[diff_buf].filetype = "diff"

    vim.fn.jobstart({ "git", "diff", "--cached", "--stat", "-p" }, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        if data then
          vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, data)
        end
      end,
    })

    vim.cmd("rightbelow vsplit")
    vim.api.nvim_win_set_buf(0, diff_buf)
    vim.cmd("wincmd p")
  end,
  desc = "show diff in split when editing commit message",
})
