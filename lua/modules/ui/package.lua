local package = require('core.pack').package
local conf = require('modules.ui.config')

package({ 'glepnir/zephyr-nvim', config = conf.zephyr })

package({ 'glepnir/dashboard-nvim', config = conf.dashboard })

package({
    'nvim-tree/nvim-tree.lua',
    cmd = 'NvimTreeToggle',
    config = conf.nvim_tree,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
})

package({
    'akinsho/nvim-bufferline.lua',
    config = conf.nvim_bufferline,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
})

package({
    'glepnir/galaxyline.nvim',
    config = conf.galaxyline,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
})

package({
    'lewis6991/gitsigns.nvim',
    event = { 'BufRead', 'BufNewFile' },
    config = conf.gitsigns,
})

package({
    'ray-x/navigator.lua',
    dependencies = {
        { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
        { 'neovim/nvim-lspconfig' },
        { 'nvim-treesitter/nvim-treesitter' },
    },
    config = conf.navigator,
})

-- 'lukas-reineke/indent-blankline.nvim'
local enable_indent_filetype = {
    'go',
    'lua',
    'sh',
    'rust',
    'cpp',
    'typescript',
    'typescriptreact',
    'javascript',
    'json',
    'python',
}

package({
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufRead',
    ft = enable_indent_filetype,
    config = conf.indent_blankline,
})
