local keymap = require('core.keymap')
local silent, noremap = keymap.silent, keymap.noremap
local new_opts = keymap.new_opts

local config = {}

function config.telescope()
  require('telescope').setup({
    defaults = {
      layout_config = {
        horizontal = { prompt_position = 'top', results_width = 0.6 },
        vertical = { mirror = false },
      },
      sorting_strategy = 'ascending',
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })
  require('telescope').load_extension('fzy_native')
end

function config.nvim_dap()
  local dap, dapui = require('dap'), require('dapui')

  require('nvim-dap-virtual-text').setup()
  require('mason-nvim-dap').setup({
    ensure_installed = { 'delve' },
  })

  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
  end

  -- dap.defaults.fallback.terminal_win_cmd = '20split new'
  -- vim.fn.sign_define('DapBreakpoint', { text = '🟥', texthl = '', linehl = '', numhl = '' })
  -- vim.fn.sign_define('DapBreakpointRejected', { text = '🟦', texthl = '', linehl = '', numhl = '' })
  -- vim.fn.sign_define('DapStopped', { text = '⭐️', texthl = '', linehl = '', numhl = '' })
  --
  -- vim.keymap.set('n', '<leader>dh', function()
  --   require('dap').toggle_breakpoint()
  -- end)
  -- vim.keymap.set('n', '<leader>dH', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
  -- vim.keymap.set({ 'n', 't' }, '<A-k>', function()
  --   require('dap').step_out()
  -- end)
  -- vim.keymap.set({ 'n', 't' }, '<A-l>', function()
  --   require('dap').step_into()
  -- end)
  -- vim.keymap.set({ 'n', 't' }, '<A-j>', function()
  --   require('dap').step_over()
  -- end)
  -- vim.keymap.set({ 'n', 't' }, '<A-h>', function()
  --   require('dap').continue()
  -- end)
  -- vim.keymap.set('n', '<leader>dn', function()
  --   require('dap').run_to_cursor()
  -- end)
  -- vim.keymap.set('n', '<leader>dc', function()
  --   require('dap').terminate()
  -- end)
  -- vim.keymap.set('n', '<leader>dR', function()
  --   require('dap').clear_breakpoints()
  -- end)
  -- vim.keymap.set('n', '<leader>de', function()
  --   require('dap').set_exception_breakpoints({ 'all' })
  -- end)
  -- vim.keymap.set('n', '<leader>da', function()
  --   -- require('debugHelper').attach()
  --   -- print("attaching")
  --   -- dap.run({
  --   --   type = 'node2',
  --   --   request = 'attach',
  --   --   cwd = vim.fn.getcwd(),
  --   --   sourceMaps = true,
  --   --   protocol = 'inspector',
  --   --   skipFiles = {'<node_internals>/**/*.js'},
  --   -- })
  --
  -- end)
  -- vim.keymap.set('n', '<leader>dA', function()
  --   -- require('debugHelper').attachToRemote()
  --   -- print("attaching")
  --   -- dap.run({
  --   --   type = 'node2',
  --   --   request = 'attach',
  --   --   address = "127.0.0.1",
  --   --   port = 9229,
  --   --   localRoot = vim.fn.getcwd(),
  --   --   remoteRoot = "/home/vcap/app",
  --   --   sourceMaps = true,
  --   --   protocol = 'inspector',
  --   --   skipFiles = {'<node_internals>/**/*.js'},
  --   -- })
  --
  -- end)
  -- vim.keymap.set('n', '<leader>di', function()
  --   require('dap.ui.widgets').hover()
  -- end)
  -- vim.keymap.set('n', '<leader>d?', function()
  --   local widgets = require('dap.ui.widgets')
  --   widgets.centered_float(widgets.scopes)
  -- end)
  -- vim.keymap.set('n', '<leader>dk', ':lua require"dap".up()<CR>zz')
  -- vim.keymap.set('n', '<leader>dj', ':lua require"dap".down()<CR>zz')
  -- vim.keymap.set('n', '<leader>dr', ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
  -- vim.keymap.set('n', '<leader>du', ':lua require"dapui".toggle()<CR>')
  --
  -- -- nvim-telescope/telescope-dap.nvim
  -- require('telescope').load_extension('dap')
  -- vim.keymap.set('n', '<leader>ds', ':Telescope dap frames<CR>')
  -- vim.keymap.set('n', '<leader>dc', ':Telescope dap commands<CR>')
  -- vim.keymap.set('n', '<leader>db', ':Telescope dap list_breakpoints<CR>')

  vim.keymap.set('n', '<F5>', function()
    require('dap').continue()
  end, new_opts(noremap, silent, 'DAP: Continue'))
  vim.keymap.set('n', '<F10>', function()
    require('dap').step_over()
  end, new_opts(noremap, silent, 'DAP: Step Over'))
  vim.keymap.set('n', '<F7>', function()
    require('dap').step_into()
  end, new_opts(noremap, silent, 'DAP: Step Into'))
  vim.keymap.set('n', '<F8>', function()
    require('dap').step_out()
  end, new_opts(noremap, silent, 'DAP: Step Out'))
  vim.keymap.set('n', '<F9>', function()
    require('dap').toggle_breakpoint()
  end, new_opts(noremap, silent, 'DAP: Toggle Breakpoint'))
  vim.keymap.set('n', '<F11>', function()
    require('dap').set_breakpoint()
  end, new_opts(noremap, silent, 'DAP: Set Breakpoint'))
  vim.keymap.set('n', '<F12>', function()
    require('dap').clear_breakpoints()
  end, new_opts(noremap, silent, 'DAP: Clear Breakpoint'))
  vim.keymap.set('n', '<space>lp', function()
    require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
  end, new_opts(noremap, silent, 'DAP: Set Breakpoint With Log Message'))
  vim.keymap.set('n', '<space>dr', function()
    require('dap').repl.open()
  end, new_opts(noremap, silent, 'DAP: Repl Open'))
  vim.keymap.set('n', '<space>dl', function()
    require('dap').run_last()
  end, new_opts(noremap, silent, 'DAP: Run Last'))
  vim.keymap.set({ 'n', 'v' }, '<space>dh', function()
    require('dap.ui.widgets').hover()
  end, new_opts(noremap, silent, 'DAP.UI.WIDGETS: Hover'))
  vim.keymap.set({ 'n', 'v' }, '<space>dp', function()
    require('dap.ui.widgets').preview()
  end, new_opts(noremap, silent, 'DAP.UI.WIDGETS: Preview'))
  vim.keymap.set('n', '<space>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
  end, new_opts(noremap, silent, 'DAP.UI.WIDGETS: Centered Float widgets.frames'))
  vim.keymap.set('n', '<space>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
  end, new_opts(noremap, silent, 'DAP.UI.WIDGETS: Centered Float widgets.scopes'))

  dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
      command = 'dlv',
      args = { 'dap', '-l', '127.0.0.1:${port}' },
      options = {
        env = {},
      },
    },
  }

  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  dap.configurations.go = {
    {
      type = 'delve',
      name = 'Debug File',
      request = 'launch',
      program = '${file}',
    },
    {
      type = 'delve',
      name = 'Debug test file', -- configuration for debugging test files
      request = 'launch',
      mode = 'test',
      program = '${file}',
    },
    -- works with go.mod packages and sub packages
    {
      type = 'delve',
      name = 'Debug test (go.mod)',
      request = 'launch',
      mode = 'test',
      program = './${relativeFileDirname}',
    },
    {
      type = 'delve',
      name = 'Debug Application (Apollo)',
      request = 'launch',
      mode = 'debug',
      program = '${workspaceFolder}/main.go',
      args = { 'start', '--config=./config/local/config.yaml' },
    },
  }
end

function config.toggle_term()
  require('toggleterm').setup()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new({
    cmd = 'lazygit',
    dir = 'git_dir',
    direction = 'float',
    float_opts = {
      border = 'double',
    },
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd('startinsert!')
      vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
    end,
    -- function to run on closing the terminal
    on_close = function(term)
      vim.cmd('startinsert!')
    end,
  })

  vim.keymap.set('n', '<space>G', function()
    lazygit:toggle()
  end, { desc = 'ToggleTerm: LazyGit' })
end

return config
