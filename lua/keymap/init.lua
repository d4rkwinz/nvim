local keymap = require('core.keymap')
local nmap, imap, cmap, xmap = keymap.nmap, keymap.imap, keymap.cmap, keymap.xmap
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local cmd = keymap.cmd

-- leaderkey
-- Use space as leader key
vim.g.mapleader = ' '

nmap({ ' ', '', opts(noremap) })
xmap({ ' ', '', opts(noremap) })

-- usage example
nmap({
  -- noremal remap
  -- close buffer
  { '<C-x>k', cmd('bdelete'), opts(noremap, silent) },
  -- save
  { '<C-s>', cmd('write'), opts(noremap) },
  -- yank
  { 'Y', 'y$', opts(noremap) },
  -- buffer jump
  { ']b', cmd('bn'), opts(noremap) },
  { '[b', cmd('bp'), opts(noremap) },
  -- remove trailing white space
  { '<Leader>t', cmd('TrimTrailingWhitespace'), opts(noremap) },
  --- copy/patse a line to below
  { '<M-d>', 'yyp', opts(noremap) },
  { '<M-S-j>', 'ddjP', opts(noremap) },
  { '<M-S-k>', 'ddkP', opts(noremap) },
  -- window jump
  { '<C-h>', '<C-w>h', opts(noremap) },
  { '<C-l>', '<C-w>l', opts(noremap) },
  { '<C-j>', '<C-w>j', opts(noremap) },
  { '<C-k>', '<C-w>k', opts(noremap) },
})

imap({
  -- insert mode
  { '<C-x>', '<Bs>', opts(noremap) },
  { '<C-e>', '<End>', opts(noremap) },
  { '<C-s>', cmd('write'), opts(noremap) },
  { 'jk', '<ESC>', opts(noremap) },
  { 'kj', '<ESC>', opts(noremap) },
})

-- commandline remap
cmap({ '<C-b>', '<Left>', opts(noremap) })
-- usage of plugins
nmap({
  -- plugin manager: Lazy.nvim
  { '<Leader>pu', cmd('Lazy update'), opts(noremap, silent) },
  { '<Leader>pi', cmd('Lazy install'), opts(noremap, silent) },
  -- dashboard
  { '<Leader>n', cmd('DashboardNewFile'), opts(noremap, silent) },
  { '<Leader>ss', cmd('SessionSave'), opts(noremap, silent) },
  { '<Leader>sl', cmd('SessionLoad'), opts(noremap, silent) },
  -- nvimtree
  { '<Leader>e', cmd('NvimTreeToggle'), opts(noremap, silent) },
  { '<Leader>r', cmd('NvimTreeRefresh'), opts(noremap, silent) },
  -- Telescope
  { '<Leader>b', cmd('Telescope buffers'), opts(noremap, silent) },
  { '<Leader>f/', cmd('Telescope live_grep'), opts(noremap, silent) },
  { '<Leader>f.', cmd('Telescope find_files'), opts(noremap, silent) },
  -- live-server
  { '<Leader>lb', cmd('LiveServerStart'), opts(noremap, silent) },
  { '<Leader>le', cmd('LiveServerStop'), opts(noremap, silent) },
})
