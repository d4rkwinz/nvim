local config = {}

function config.zephyr()
  vim.cmd('colorscheme zephyr')
end

function config.dashboard()
  local db = require('dashboard')
  local z = require('zephyr')
  db.session_directory = vim.env.HOME .. '/.cache/nvim/session'
  db.preview_file_height = 11
  db.preview_file_width = 88
  db.custom_center = {
    {
      icon = '  ',
      icon_hl = { fg = z.red },
      desc = 'Update Plugins                          ',
      shortcut = 'SPC p u',
      action = 'Lazy update',
    },
    {
      icon = '  ',
      icon_hl = { fg = z.yellow },
      desc = 'Recently opened files                   ',
      action = 'Telescope oldfiles',
      shortcut = 'SPC f h',
    },
    {
      icon = '  ',
      icon_hl = { fg = z.cyan },
      desc = 'Find  File                              ',
      action = 'Telescope find_files find_command=rg,--hidden,--files',
      shortcut = 'SPC f f',
    },
    {
      icon = '  ',
      icon_hl = { fg = z.blue },
      desc = 'File Browser                            ',
      action = 'Telescope file_browser',
      shortcut = 'SPC   e',
    },
    {
      icon = '  ',
      icon_hl = { fg = z.oragne },
      desc = 'Find  word                              ',
      action = 'Telescope live_grep',
      shortcut = 'SPC f b',
    },
    {
      icon = '  ',
      icon_hl = { fg = z.redwine },
      desc = 'Open Personal dotfiles                  ',
      action = 'Telescope dotfiles path=' .. vim.env.HOME .. '/.dotfiles',
      shortcut = 'SPC f d',
    },
  }
  db.setup({
    theme = 'hyper',
    config = {
      week_header = {
        enable = true,
      },
      shortcut = {
        { desc = ' Update', group = '@property', action = 'Lazy update', key = 'u' },
        {
          desc = ' Files',
          group = 'Label',
          action = 'Telescope find_files',
          key = 'f',
        },
        {
          desc = ' Apps',
          group = 'DiagnosticHint',
          action = 'Telescope app',
          key = 'a',
        },
        {
          desc = ' dotfiles',
          group = 'Number',
          action = 'Telescope dotfiles',
          key = 'd',
        },
      },
    },
  })
end

function config.nvim_tree()
  require('nvim-tree').setup({
    disable_netrw = false,
    hijack_cursor = true,
    hijack_netrw = true,
  })
end

function config.nvim_bufferline()
  require('bufferline').setup({
    options = {
      modified_icon = '✥',
      buffer_close_icon = '',
      always_show_bufferline = false,
    },
  })
end

function config.galaxyline()
  require('modules.ui.conf_eviline')
end

function config.gitsigns()
  require('gitsigns').setup({
    signs = {
      add = { hl = 'GitGutterAdd', text = '▍' },
      change = { hl = 'GitGutterChange', text = '▍' },
      delete = { hl = 'GitGutterDelete', text = '▍' },
      topdelete = { hl = 'GitGutterDeleteChange', text = '▔' },
      changedelete = { hl = 'GitGutterChange', text = '▍' },
      untracked = { hl = 'GitGutterAdd', text = '▍' },
    },

    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          return ']c'
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return '<Ignore>'
      end, { expr = true })

      map('n', '[c', function()
        if vim.wo.diff then
          return '[c'
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      map('n', '<space>hs', gs.stage_hunk, { noremap = true, desc = 'Gitsigns: Stage Hunk' })
      map('n', '<space>hr', gs.reset_hunk, { noremap = true, desc = 'Gitsigns: Reset Hunk' })
      map('v', '<space>hs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { noremap = true, desc = 'Gitsigns: Stage Hunk Line' })
      map('v', '<space>hr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { noremap = true, desc = 'Gitsigns: Reset Hunk Line' })
      map('n', '<space>hS', gs.stage_buffer, { noremap = true, desc = 'Gitsigns: Stage Buffer' })
      map('n', '<space>hu', gs.undo_stage_hunk, { noremap = true, desc = 'Gitsigns: Undo Stage Hunk' })
      map('n', '<space>hR', gs.reset_buffer, { noremap = true, desc = 'Gitsigns: Reset Buffer' })
      map('n', '<space>hp', gs.preview_hunk, { noremap = true, desc = 'Gitsigns: Preview Hunk' })
      map('n', '<space>hb', function()
        gs.blame_line({ full = true })
      end, { noremap = true, desc = 'Gitsigns: Blame Line' })
      map(
        'n',
        '<space>tb',
        gs.toggle_current_line_blame,
        { noremap = true, desc = 'Gitsigns: Toggle Current Line Blame' }
      )
      map('n', '<space>hd', gs.diffthis, { noremap = true, desc = 'Gitsigns: Diffthis' })
      map('n', '<space>hD', function()
        gs.diffthis('~')
      end, { noremap = true, desc = 'Gitsigns: Diffthis ~' })
      map('n', '<space>td', gs.toggle_deleted, { noremap = true, desc = 'Gitsigns: Toggle Deleted' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
    -- keymaps = {
    --   -- Default keymap options
    --   noremap = true,
    --   buffer = true,
    --
    --   ['n ]g'] = { expr = true, "&diff ? ']g' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
    --   ['n [g'] = { expr = true, "&diff ? '[g' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
    --
    --   ['n <Leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    --   ['n <Leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    --   ['n <Leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    --   ['n <Leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    --   ['n <Leader>hb'] = '<cmd>lua require"gitsigns".blame_line()<CR>',
    --
    --   -- Text objects
    --   ['o ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
    --   ['x ih'] = ':<C-U>lua require"gitsigns".text_object()<CR>',
    -- },
  })
end

function config.navigator()
  require('navigator').setup({
    lsp = {
      format_on_save = false,
      diagnostic = {
        virtual_text = false,
      },
    },
  })
end

function config.indent_blankline()
  require('indent_blankline').setup({
    char = '│',
    use_treesitter_scope = true,
    show_first_indent_level = true,
    show_current_context = false,
    show_current_context_start = false,
    show_current_context_start_on_current_line = false,
    filetype_exclude = {
      'dashboard',
      'DogicPrompt',
      'log',
      'fugitive',
      'gitcommit',
      'packer',
      'markdown',
      'json',
      'txt',
      'vista',
      'help',
      'todoist',
      'git',
      'TelescopePrompt',
      'undotree',
    },
    buftype_exclude = { 'terminal', 'nofile', 'prompt' },
    context_patterns = {
      'class',
      'function',
      'method',
      'block',
      'list_literal',
      'selector',
      '^if',
      '^table',
      'if_statement',
      'while',
      'for',
    },
  })
end

return config
