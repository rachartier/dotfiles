vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
}, { confirm = false, load = false })

local disabled_indent = { "yaml", "bash", "python" }

---@type table<string, boolean>?
local available

local function is_installed(lang)
  return vim.list_contains(require("nvim-treesitter").get_installed("parsers"), lang)
end

local function has_query(lang, query)
  return vim.treesitter.query.get(lang, query) ~= nil
end

local function start_treesitter(bufnr, lang)
  if not pcall(vim.treesitter.start, bufnr) then
    return
  end

  if has_query(lang, "folds") then
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  end

  if
    has_query(lang, "indents") and not vim.list_contains(disabled_indent, vim.bo[bufnr].filetype)
  then
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local function attach_treesitter(bufnr)
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  if not lang or not available[lang] then
    return
  end

  if not is_installed(lang) then
    require("nvim-treesitter").install({ lang }):await(function()
      start_treesitter(bufnr, lang)
    end)
    return
  end

  start_treesitter(bufnr, lang)
end

local function load_treesitter()
  vim.cmd.packadd("nvim-treesitter")
  vim.cmd.packadd("nvim-treesitter-textobjects")

  available = {}
  for _, parser in ipairs(require("nvim-treesitter").get_available()) do
    available[parser] = true
  end

  local ensure_installed = { "regex", "bash" }
  for _, lang in ipairs(require("config.languages")) do
    for _, parser_name in ipairs(lang.treesitter or {}) do
      table.insert(ensure_installed, parser_name)
    end
    if not lang.treesitter then
      for _, filetype in ipairs(lang.filetypes) do
        local parser_name = filetype ~= "*" and vim.treesitter.language.get_lang(filetype)
        if parser_name then
          table.insert(ensure_installed, parser_name)
        end
      end
    end
  end
  require("nvim-treesitter").install(vim.list.unique(ensure_installed))

  for _, key in ipairs({ "<C-down>", "<C-j>" }) do
    vim.keymap.set({ "n", "x", "o" }, key, function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
    end, { silent = true, desc = "next function start" })
  end

  for _, key in ipairs({ "<C-up>", "<C-k>" }) do
    vim.keymap.set({ "n", "x", "o" }, key, function()
      require("nvim-treesitter-textobjects.move").goto_previous_start(
        "@function.outer",
        "textobjects"
      )
    end, { silent = true, desc = "previous function start" })
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("lazy_treesitter", { clear = true }),
  callback = function(ev)
    if not available then
      if vim.bo[ev.buf].buftype ~= "" then
        return
      end
      load_treesitter()
    end
    attach_treesitter(ev.buf)
  end,
  desc = "lazy-load and start treesitter",
})
