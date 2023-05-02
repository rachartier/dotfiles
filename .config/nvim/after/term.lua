-- Thanks! https://github.com/nvimdev/lspsaga.nvim/blob/main/lua/lspsaga/floaterm.lua
--
local u = require("utils")

local vim, api, lsp = vim, vim.api, vim.lsp
local ctx = {}

local M = {}

local config = {
    ui = {
        border = u.border_chars_outer_thin,
        winblend = 10
    }
}

function M:get_shadow_config()
    local opts = {
        relative = 'editor',
        style = 'minimal',
        width = vim.o.columns,
        height = vim.o.lines,
        row = 0,
        col = 0,
    }
    return opts
end

function M:make_floating_popup_options(width, height, opts)
    vim.validate({
        opts = { opts, 't', true },
    })
    opts = opts or {}
    vim.validate({
        ['opts.offset_x'] = { opts.offset_x, 'n', true },
        ['opts.offset_y'] = { opts.offset_y, 'n', true },
    })
    local new_option = {}

    new_option.style = opts.style or 'minimal'
    new_option.width = width
    new_option.height = height

    if opts.focusable ~= nil then
        new_option.focusable = opts.focusable
    end

    new_option.noautocmd = opts.noautocmd or true

    new_option.relative = opts.relative and opts.relative or 'cursor'
    new_option.anchor = opts.anchor or nil
    if new_option.relative == 'win' then
        new_option.bufpos = opts.bufpos or nil
        new_option.win = opts.win or nil
    end

    if opts.title then
        new_option.title = opts.title
        new_option.title_pos = opts.title_pos or 'center'
    end

    new_option.zindex = opts.zindex or nil

    if not opts.row and not opts.col and not opts.bufpos then
        local lines_above = vim.fn.winline() - 1
        local lines_below = vim.fn.winheight(0) - lines_above
        new_option.anchor = ''

        local pum_pos = vim.fn.pum_getpos()
        local pum_vis = not vim.tbl_isempty(pum_pos) -- pumvisible() can be true and pum_pos() returns {}
        if pum_vis and vim.fn.line('.') >= pum_pos.row or not pum_vis and lines_above < lines_below then
            new_option.anchor = 'N'
            new_option.row = 1
        else
            new_option.anchor = 'S'
            new_option.row = 0
        end

        if vim.fn.wincol() + width <= vim.o.columns then
            new_option.anchor = new_option.anchor .. 'W'
            new_option.col = 0
        else
            new_option.anchor = new_option.anchor .. 'E'
            new_option.col = 1
        end
    else
        new_option.row = opts.row
        new_option.col = opts.col
    end

    return new_option
end

function M:generate_win_opts(contents, opts)
    opts = opts or {}
    local win_width, win_height
    if opts.no_size_override and opts.width and opts.height then
        win_width, win_height = opts.width, opts.height
    else
        win_width, win_height = lsp.util._make_floating_popup_size(contents, opts)
    end

    opts = M.make_floating_popup_options(self, win_width, win_height, opts)
    return opts
end

function M:open_shadow_float_win(content_opts, opts)
    local shadow_bufnr, shadow_winid = M.open_shadow_win(self)
    local contents_bufnr, contents_winid = M.create_win_with_border(self, content_opts, opts)
    return contents_bufnr, contents_winid, shadow_bufnr, shadow_winid
end

function M:create_win_with_border(content_opts, opts)
    vim.validate({
        content_opts = { content_opts, 't' },
        contents = { content_opts.content, 't', true },
        opts = { opts, 't', true },
    })

    local contents, filetype = content_opts.contents, content_opts.filetype
    local enter = content_opts.enter or false
    opts = opts or {}
    opts = M.generate_win_opts(self, contents, opts)

    local highlight = content_opts.highlight or {}

    local normal = highlight.normal or 'LspNormal'
    local border_hl = highlight.border or 'LspBorder'

    if content_opts.noborder then
        opts.border = 'none'
    else
        opts.border = content_opts.border_side
        and M.combine_border(config.ui.border, content_opts.border_side, border_hl)
        or config.ui.border
    end

    -- create contents buffer
    local bufnr = content_opts.bufnr or api.nvim_create_buf(false, false)
    -- buffer settings for contents buffer
    -- Clean up input: trim empty lines from the end, pad
    ---@diagnostic disable-next-line: missing-parameter
    local content = lsp.util._trim(contents)

    if filetype then
        api.nvim_buf_set_option(bufnr, 'filetype', filetype)
    end

    content = vim.tbl_flatten(vim.tbl_map(function(line)
        if string.find(line, '\n') then
            return vim.split(line, '\n')
        end
        return line
    end, content))

    if not vim.tbl_isempty(content) then
        api.nvim_buf_set_lines(bufnr, 0, -1, true, content)
    end

    if not content_opts.bufnr then
        api.nvim_set_option_value('modifiable', false, { buf = bufnr })
        api.nvim_set_option_value('bufhidden', content_opts.bufhidden or 'wipe', { buf = bufnr })
        api.nvim_set_option_value('buftype', content_opts.buftype or 'nofile', { buf = bufnr })
    end

    local winid = api.nvim_open_win(bufnr, enter, opts)
    api.nvim_set_option_value(
    'winblend',
    content_opts.winblend or config.ui.winblend,
    { scope = 'local', win = winid }
    )
    api.nvim_set_option_value('wrap', content_opts.wrap or false, { scope = 'local', win = winid })

    api.nvim_set_option_value(
    'winhl',
    'Normal:' .. normal .. ',FloatBorder:' .. border_hl,
    { scope = 'local', win = winid }
    )

    api.nvim_set_option_value('winbar', '', { scope = 'local', win = winid })
    return bufnr, winid
end

function M:open_shadow_win()
    local opts = M.get_shadow_config(self)
    local shadow_winhl = 'Normal:FloatShadow'
    local shadow_bufnr = api.nvim_create_buf(false, false)
    local shadow_winid = api.nvim_open_win(shadow_bufnr, true, opts)
    api.nvim_set_option_value('winhl', shadow_winhl, { scope = 'local', win = shadow_winid })
    api.nvim_set_option_value('winblend', 70, { scope = 'local', win = shadow_winid })
    api.nvim_set_option_value('bufhidden', 'wipe', { buf = shadow_bufnr })
    return shadow_bufnr, shadow_winid
end

function M:open_float_terminal(command)
    local cur_buf = api.nvim_get_current_buf()
    if not vim.tbl_isempty(ctx) and ctx.term_bufnr == cur_buf then
        api.nvim_win_close(ctx.term_winid, true)
        if ctx.shadow_winid and api.nvim_win_is_valid(ctx.shadow_winid) then
            api.nvim_win_close(ctx.shadow_winid, true)
        end
        ctx.term_winid = nil
        ctx.shadow_winid = nil
        if ctx.cur_win and ctx.pos then
            api.nvim_set_current_win(ctx.cur_win)
            api.nvim_win_set_cursor(0, ctx.pos)
            ctx.cur_win = nil
            ctx.pos = nil
        end
        return
    end

    local cmd = command and command or os.getenv('SHELL')
    -- calculate our floating window size
    local win_height = math.ceil(vim.o.lines * 0.7)
    local win_width = math.ceil(vim.o.columns * 0.7)

    -- and its starting position
    local row = math.ceil((vim.o.lines - win_height) * 0.4)
    local col = math.ceil((vim.o.columns - win_width) * 0.5)

    -- set some options
    local opts = {
        style = 'minimal',
        relative = 'editor',
        width = win_width,
        height = win_height,
        row = row,
        col = col,
    }

    local content_opts = {
        contents = {},
        enter = true,
        bufhidden = 'hide',
        highlight = {
            normal = 'TerminalNormal',
            border = 'TerminalBorder',
        },
    }
    local spawn_new = vim.tbl_isempty(ctx) and true or false

    if not spawn_new then
        content_opts.bufnr = ctx.term_bufnr
        api.nvim_buf_set_option(ctx.term_bufnr, 'modified', false)
    end
    ctx.cur_win = api.nvim_get_current_win()
    ctx.pos = api.nvim_win_get_cursor(0)

    ctx.term_bufnr, ctx.term_winid, ctx.shadow_bufnr, ctx.shadow_winid =
    M.open_shadow_float_win(self, content_opts, opts)

    if spawn_new then
        vim.fn.termopen(cmd, {
            on_exit = function()
                if ctx.term_winid and api.nvim_win_is_valid(ctx.term_winid) then
                    api.nvim_win_close(ctx.term_winid, true)
                end
                if ctx.shadow_winid and api.nvim_win_is_valid(ctx.shadow_winid) then
                    api.nvim_win_close(ctx.shadow_winid, true)
                end
                ctx = {}
            end,
        })
    end

    vim.cmd('startinsert!')

    api.nvim_create_autocmd('WinClosed', {
        buffer = ctx.term_bufnr,
        callback = function()
            if ctx.shadow_winid and api.nvim_win_is_valid(ctx.shadow_winid) then
                api.nvim_win_close(ctx.shadow_winid, true)
                ctx.shadow_winid = nil
            end
        end,
    })
end

function M:close_float_terminal()
    if ctx.term_winid and api.nvim_win_is_valid(ctx.term_winid) then
        api.nvim_win_close(ctx.term_winid, true)
    end
end

vim.keymap.set('n', '<leader>tg', M.open_float_terminal)
vim.keymap.set('t', '<leader>tg', M.close_float_terminal)
