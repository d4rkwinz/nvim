local config = {}

function config.nvim_treesitter()
    vim.api.nvim_command('set foldmethod=expr')
    vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'c',
            'cpp',
            'rust',
            'zig',
            'lua',
            'go',
            'python',
            'proto',
            'typescript',
            'javascript',
            'tsx',
            'css',
            'scss',
            'diff',
            'dockerfile',
            'gomod',
            'gosum',
            'gowork',
            'graphql',
            'html',
            'sql',
            'markdown',
            'markdown_inline',
            'json',
            'jsonc',
            'vimdoc',
            'vim',
            'cmake',
        },
        ignore_install = { 'phpdoc' },
        highlight = {
            enable = true,
            disable = function(_, buf)
                local bufname = vim.api.nvim_buf_get_name(buf)
                local max_filesize = 300 * 1024
                local ok, stats = pcall(vim.uv.fs_stat, bufname)
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            additional_vim_regex_highlighting = false,
        },
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                },
            },
        },
    })
end

return config
