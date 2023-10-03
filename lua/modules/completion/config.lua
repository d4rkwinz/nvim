local config = {}

function config.nvim_cmp()
    local cmp = require('cmp')

    cmp.setup({
        preselect = cmp.PreselectMode.Item,
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        snippet = {
            -- REQUIRED - you must specify a snippet engine
            expand = function(args)
                -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            -- { name = 'vsnip' }, -- For vsnip users.
            { name = 'luasnip' }, -- For luasnip users.
            -- { name = 'ultisnips' }, -- For ultisnips users.
            -- { name = 'snippy' }, -- For snippy users.
        }, {
            { name = 'buffer' },
        }),
    })
end

function config.lua_snip()
    local ls = require('luasnip')
    local types = require('luasnip.util.types')
    ls.config.set_config({
        history = true,
        enable_autosnippets = true,
        updateevents = 'TextChanged,TextChangedI',
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { '<- choiceNode', 'Comment' } },
                },
            },
        },
    })
    require('luasnip.loaders.from_lua').lazy_load({ paths = vim.fn.stdpath('config') .. '/snippets' })
    require('luasnip.loaders.from_vscode').lazy_load()
    require('luasnip.loaders.from_vscode').lazy_load({
        paths = { './snippets/' },
    })
end

function config.null_ls()
    local null_ls = require('null-ls')

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/formatting
    local formatting = null_ls.builtins.formatting

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/diagnostics
    local diagnostics = null_ls.builtins.diagnostics

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/completion
    local completion = null_ls.builtins.completion

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/lua/null-ls/builtins/code_actions
    local code_actions = null_ls.builtins.code_actions

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

    null_ls.setup({
        debug = true,
        sources = {
            -- formatting.prettier.with({ extra_args = { '--no-semi', '--single-quote', '--jsx-single-quote' } }),
            formatting.eslint_d,
            formatting.prettierd,
            -- formatting.prettierd.with({
            --   filetypes = {
            --     'css',
            --     'scss',
            --     'less',
            --     'html',
            --     'json',
            --     'yaml',
            --     'markdown',
            --     'graphql',
            --   },
            -- }),
            formatting.stylua,
            formatting.cljstyle,
            diagnostics.eslint_d,
            diagnostics.luacheck,
            diagnostics.clj_kondo,
            completion.luasnip,
            code_actions.eslint_d,
        },
        on_attach = function(client, bufnr)
            if client.supports_method('textDocument/formatting') then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.code_action({ context = { only = { 'source.fixAll' } }, apply = true })
                    end,
                })
            end
        end,
    })
end

function config.autoclose()
    local autoclose = require('autoclose')
    autoclose.setup({
        keys = {
            ['('] = { escape = false, close = true, pair = '()' },
            ['['] = { escape = false, close = true, pair = '[]' },
            ['{'] = { escape = false, close = true, pair = '{}' },

            ['>'] = { escape = true, close = false, pair = '<>' },
            [')'] = { escape = true, close = false, pair = '()' },
            [']'] = { escape = true, close = false, pair = '[]' },
            ['}'] = { escape = true, close = false, pair = '{}' },

            ['"'] = { escape = true, close = true, pair = '""' },
            ["'"] = { escape = true, close = true, pair = "''" },
            ['`'] = { escape = true, close = true, pair = '``' },
        },
        options = {
            disabled_filetypes = { 'text' },
            disable_when_touch = false,
            touch_regex = '[%w(%[{]',
            pair_spaces = false,
            auto_indent = true,
        },
    })
end

function config.codeium()
    vim.keymap.set('i', '<C-y>', function()
        return vim.fn['codeium#Accept']()
    end, { expr = true })
    vim.keymap.set('i', '<c-;>', function()
        return vim.fn['codeium#CycleCompletions'](1)
    end, { expr = true })
    vim.keymap.set('i', '<c-,>', function()
        return vim.fn['codeium#CycleCompletions'](-1)
    end, { expr = true })
    vim.keymap.set('i', '<c-x>', function()
        return vim.fn['codeium#Clear']()
    end, { expr = true })
end

return config
