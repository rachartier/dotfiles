local M = {}
local utils = require("utils")

local ns_cache = {}

local function get_ns_name(id)
  if not ns_cache[id] then
    for name, ns_id in pairs(vim.api.nvim_get_namespaces()) do
      ns_cache[ns_id] = name
    end
  end
  return ns_cache[id] or ""
end

local function get_sign(buf, row, gitsigns)
  local extmarks = vim.api.nvim_buf_get_extmarks(
    buf,
    -1,
    { row, 0 },
    { row, -1 },
    { details = true, type = "sign" }
  )
  local best, best_priority = nil, -1
  for _, mark in ipairs(extmarks) do
    local d = mark[4]
    if d.sign_text then
      local is_git = get_ns_name(d.ns_id):match("^gitsigns") ~= nil
      if is_git == gitsigns and (d.priority or 0) > best_priority then
        best, best_priority = d, d.priority or 0
      end
    end
  end
  return best
end

local function pad(text, width)
  return text .. string.rep(" ", width - #text)
end

function _G.Stc_signs()
  if vim.v.virtnum ~= 0 then
    return "  "
  end
  local sign = get_sign(vim.api.nvim_get_current_buf(), vim.v.lnum - 1, false)
  if not sign then
    return "   "
  end
  return utils.hl_str(sign.sign_hl_group or "SignColumn", pad(vim.trim(sign.sign_text), 3))
end

function _G.Stc_num()
  local nu, rnu = vim.wo.number, vim.wo.relativenumber

  if not nu and not rnu then
    return ""
  end

  if vim.v.virtnum < 0 then
    return utils.hl_str("LineNr", " ")
  end
  if vim.v.virtnum > 0 then
    local wraps = vim.api.nvim_win_text_height(
      0,
      { start_row = vim.v.lnum - 1, end_row = vim.v.lnum - 1 }
    )["all"] - 1
    return utils.hl_str("LineNr", vim.v.virtnum == wraps and "└" or "├")
  end

  local lnum, relnum = vim.v.lnum, vim.v.relnum
  local num = rnu and (relnum == 0 and lnum or relnum) or lnum
  local cur = rnu and relnum == 0 or vim.fn.line(".") == lnum
  local mode = vim.fn.mode()
  if mode:match("[vV\22]") then
    local ok, p = pcall(
      vim.fn.getregionpos,
      vim.fn.getpos("v"),
      vim.fn.getpos("."),
      { type = mode, eol = true }
    )
    if ok and p[1] and lnum >= p[1][1][2] and lnum <= p[#p][2][2] then
      cur = true
    end
  end
  return utils.hl_str(cur and "CursorLineNr" or "LineNr", num)
end

function _G.Stc_git()
  if vim.v.virtnum ~= 0 then
    return " "
  end
  local sign = get_sign(vim.api.nvim_get_current_buf(), vim.v.lnum - 1, true)
  if not sign then
    return " "
  end
  return utils.hl_str(sign.sign_hl_group or "SignColumn", vim.trim(sign.sign_text))
end

function M.setup()
  vim.o.statuscolumn = "%{%v:lua.Stc_signs()%}%=%{%v:lua.Stc_num()%} %{%v:lua.Stc_git()%}"

  vim.api.nvim_create_autocmd("FileType", {
    pattern = {
      "Neogit*",
      "dapui_*",
      "dap-repl",
      "oil",
      "Trouble",
      "TelescopePrompt",
      "Avante",
      "AvanteInput",
      "snacks_dashboard",
    },
    callback = function()
      vim.wo.statuscolumn = ""
    end,
  })
end

return M
