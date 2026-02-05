vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    local new_key = vim.fn.keytrans(char)
    if vim.tbl_contains({ "n", "N", "*", "#", "?", "/" }, new_key) then
      vim.opt.hlsearch = true
    elseif new_key ~= "" and vim.v.hlsearch == 1 then
      vim.schedule(function()
        vim.cmd.nohlsearch()
      end)
    end
  end
end, vim.api.nvim_create_namespace("auto_hlsearch"))
