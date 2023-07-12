local package = require('core.pack').package
local conf = require('modules.lsp.config')

--[[ local function lsp_fts(type)
  type = type or nil
  local fts = {}
  fts.backend = {
    'go',
    'lua',
    'sh',
    'rust',
    'c',
    'cpp',
    'zig',
    'python',
  }

  fts.frontend = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
  }
  if not type then
    return vim.list_extend(fts.backend, fts.frontend)
  end
  return fts[type]
end ]]

package({
  'neovim/nvim-lspconfig',
  -- ft = lsp_fts(),
  dependencies = {
    {
      'williamboman/mason.nvim',
      build = ':MasonUpdate',
    },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'ray-x/lsp_signature.nvim' },
  },
  config = conf.nvim_lsp,
})

--[[ package({
  'nvimdev/lspsaga.nvim',
  cmd = 'Lspsaga term_toggle',
  config = conf.nvim_lspsaga,
}) ]]
