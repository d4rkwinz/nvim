local keymap = require('core.keymap')
local silent, noremap = keymap.silent, keymap.noremap
local new_opts = keymap.new_opts

local config = {}

function config.nvim_lsp()
  require('mason').setup()
  local language_servers = {
    'bashls',
    'cssls',
    'docker_compose_language_service',
    'dockerls',
    'eslint',
    'html',
    'lemminx',
    'marksman',
    'pyright',
    'sqlls',
    'tailwindcss',
    'tsserver',
    'yamlls',
    'zls',
  }

  local mason_language_servers = {
    'bashls',
    'clangd',
    'gopls',
    'cssls',
    'docker_compose_language_service',
    'dockerls',
    'eslint',
    'html',
    'lemminx',
    'lua_ls',
    'marksman',
    'pyright',
    'rust_analyzer',
    'sqlls',
    'tailwindcss',
    'tsserver',
    'yamlls',
    'zls',
  }

  -- Language servers to eagerly install
  require('mason-lspconfig').setup({
    ensure_installed = mason_language_servers,
  })

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local lspconfig = require('lspconfig')

  --[[ vim.keymap.set('n', '<space>lf', function()
    vim.lsp.buf.format({ async = true })
  end, new_opts(noremap, silent, 'LSP BUF: Format Code')) ]]
  vim.keymap.set('n', '<space>of', vim.diagnostic.open_float, new_opts(noremap, silent, 'DIAGNOSTIC: Open Float'))
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, new_opts(noremap, silent, 'DIAGNOSTIC: Goto Previous Diagnostic'))
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, new_opts(noremap, silent, 'DIAGNOSTIC: Goto Next Diagnostic'))
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, new_opts(noremap, silent, 'DIAGNOSTIC: Set Loc List'))
  local on_attach = function()
    -- Key bindings to be set after LSP attaches to buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        vim.api.nvim_buf_set_option(ev.buf, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        vim.api.nvim_buf_set_option(ev.buf, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')

        -- local opts = { noremap = true, buffer = ev.buf }
        vim.keymap.set(
          'n',
          'gD',
          vim.lsp.buf.declaration,
          { noremap = true, buffer = ev.buf, desc = 'LSP BUF: Go To Declaration' }
        )
        vim.keymap.set(
          'n',
          'gd',
          vim.lsp.buf.definition,
          { noremap = true, buffer = ev.buf, desc = 'LSP BUF: Go To Definition' }
        )
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, buffer = ev.buf, desc = 'LSP BUF: Hover' })
        vim.keymap.set(
          'n',
          'gI',
          vim.lsp.buf.implementation,
          { noremap = true, buffer = ev.buf, desc = 'LSP BUF: Go To Implementation' }
        )
        vim.keymap.set(
          'n',
          '<C-k>',
          vim.lsp.buf.signature_help,
          { noremap = true, buffer = ev.buf, desc = 'LSP BUF: Signature Help' }
        )
        vim.keymap.set(
          'n',
          '<space>wa',
          vim.lsp.buf.add_workspace_folder,
          { noremap = true, buffer = ev.buf, desc = 'LSP BUF: Add Workspace Folder' }
        )
        vim.keymap.set(
          'n',
          '<space>wr',
          vim.lsp.buf.remove_workspace_folder,
          { noremap = true, buffer = ev.buf, desc = 'LSP BUF: Remove Workspace Folder' }
        )
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { noremap = true, buffer = ev.buf, desc = 'LSP BUF: List Workspace Folder' })
        vim.keymap.set(
          'n',
          '<space>D',
          vim.lsp.buf.type_definition,
          { noremap = true, buffer = ev.buf, desc = 'LSP BUF: Type Definition' }
        )
        vim.keymap.set(
          'n',
          '<space>rn',
          vim.lsp.buf.rename,
          { noremap = true, buffer = ev.buf, desc = 'LSP BUF: Rename' }
        )
        vim.keymap.set(
          { 'n', 'v' },
          '<space>ca',
          vim.lsp.buf.code_action,
          { noremap = true, buffer = ev.buf, desc = 'LSP BUF: Code Action' }
        )
        vim.keymap.set(
          'n',
          'gr',
          vim.lsp.buf.references,
          { noremap = true, buffer = ev.buf, desc = 'LSP BUF: References' }
        )
      end,
    })
  end

  -- lsp_signature UI tweaks
  require('lsp_signature').setup({
    bind = true,
    handler_opts = {
      border = 'rounded',
    },
  })

  -- LSP diagnostics

  vim.opt.updatetime = 250
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = true,
    signs = true,
  })

  vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

  -- Configure individual language servers here
  for _, server in pairs(language_servers) do
    lspconfig[server].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end

  lspconfig.gopls.setup({
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    capabilities = capabilities,
    on_attach = on_attach,
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
    },
    settings = {
      gopls = {
        analyses = {
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        experimentalPostfixCompletions = true,
        gofumpt = true,
        semanticTokens = true,
        staticcheck = true,
        usePlaceholders = true,
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })

  lspconfig.lua_ls.setup({
    on_attach = on_attach,
    settings = {
      Lua = {
        diagnostics = {
          enable = true,
          globals = { 'vim' },
        },
        runtime = {
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        workspace = {
          library = {
            vim.env.VIMRUNTIME,
            vim.env.HOME .. '/.local/share/nvim/lazy/emmylua-nvim',
          },
          checkThirdParty = false,
        },
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  })

  lspconfig.clangd.setup({
    on_attach = on_attach,
    cmd = {
      'clangd',
      '--background-index',
      '--clang-tidy',
      '--header-insertion=iwyu',
    },
  })

  lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
      ['rust-analyzer'] = {
        assist = {
          importEnforceGranularity = true,
          importPrefix = 'crate',
        },
        imports = {
          granularity = {
            group = 'module',
          },
          prefix = 'self',
        },
        cargo = {
          allFeatures = true,
          buildScripts = {
            enable = true,
          },
        },
        checkOnSave = {
          -- default: `cargo check`
          -- command = "clippy"
          command = 'cargo check',
        },
        procMacro = {
          enable = true,
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true,
          },
        },
      },
    },
  })
end

function config.nvim_lspsaga()
  require('lspsaga').setup({
    symbol_in_winbar = {
      ignore_patterns = { '%w_spec' },
    },
  })
  local lspsaga_keymap = vim.keymap.set

  -- LSP finder - Find the symbol's definition
  -- If there is no definition, it will instead be hidden
  -- When you use an action in finder like "open vsplit",
  -- you can use <C-t> to jump back
  lspsaga_keymap('n', 'gh', '<cmd>Lspsaga lsp_finder<CR>')

  -- Code action
  lspsaga_keymap({ 'n', 'v' }, '<space>ca', '<cmd>Lspsaga code_action<CR>')

  -- Rename all occurrences of the hovered word for the entire file
  lspsaga_keymap('n', 'gr', '<cmd>Lspsaga rename<CR>')

  -- Rename all occurrences of the hovered word for the selected files
  lspsaga_keymap('n', 'gr', '<cmd>Lspsaga rename ++project<CR>')

  -- Peek definition
  -- You can edit the file containing the definition in the floating window
  -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
  -- It also supports tagstack
  -- Use <C-t> to jump back
  lspsaga_keymap('n', 'gp', '<cmd>Lspsaga peek_definition<CR>')

  -- Go to definition
  lspsaga_keymap('n', 'gd', '<cmd>Lspsaga goto_definition<CR>')

  -- Peek type definition
  -- You can edit the file containing the type definition in the floating window
  -- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
  -- It also supports tagstack
  -- Use <C-t> to jump back
  lspsaga_keymap('n', 'gt', '<cmd>Lspsaga peek_type_definition<CR>')

  -- Go to type definition
  lspsaga_keymap('n', 'gt', '<cmd>Lspsaga goto_type_definition<CR>')

  -- Show line diagnostics
  -- You can pass argument ++unfocus to
  -- unfocus the show_line_diagnostics floating window
  lspsaga_keymap('n', '<space>sl', '<cmd>Lspsaga show_line_diagnostics<CR>')

  -- Show buffer diagnostics
  lspsaga_keymap('n', '<space>sb', '<cmd>Lspsaga show_buf_diagnostics<CR>')

  -- Show workspace diagnostics
  lspsaga_keymap('n', '<space>sw', '<cmd>Lspsaga show_workspace_diagnostics<CR>')

  -- Show cursor diagnostics
  lspsaga_keymap('n', '<space>sc', '<cmd>Lspsaga show_cursor_diagnostics<CR>')

  -- Diagnostic jump
  -- You can use <C-o> to jump back to your previous location
  lspsaga_keymap('n', '[e', '<cmd>Lspsaga diagnostic_jump_prev<CR>')
  lspsaga_keymap('n', ']e', '<cmd>Lspsaga diagnostic_jump_next<CR>')

  -- Diagnostic jump with filters such as only jumping to an error
  lspsaga_keymap('n', '[E', function()
    require('lspsaga.diagnostic'):goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end)
  lspsaga_keymap('n', ']E', function()
    require('lspsaga.diagnostic'):goto_next({ severity = vim.diagnostic.severity.ERROR })
  end)

  -- Toggle outline
  lspsaga_keymap('n', '<space>o', '<cmd>Lspsaga outline<CR>')

  -- Hover Doc
  -- If there is no hover doc,
  -- there will be a notification stating that
  -- there is no information available.
  -- To disable it just use ":Lspsaga hover_doc ++quiet"
  -- Pressing the key twice will enter the hover window
  lspsaga_keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>')

  -- If you want to keep the hover window in the top right hand corner,
  -- you can pass the ++keep argument
  -- Note that if you use hover with ++keep, pressing this key again will
  -- close the hover window. If you want to jump to the hover window
  -- you should use the wincmd command "<C-w>w"
  lspsaga_keymap('n', 'K', '<cmd>Lspsaga hover_doc ++keep<CR>')

  -- Call hierarchy
  lspsaga_keymap('n', '<space>ci', '<cmd>Lspsaga incoming_calls<CR>')
  lspsaga_keymap('n', '<space>co', '<cmd>Lspsaga outgoing_calls<CR>')

  -- Floating terminal
  lspsaga_keymap({ 'n', 't' }, '<A-d>', '<cmd>Lspsaga term_toggle<CR>')
end

return config
