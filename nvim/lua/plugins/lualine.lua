return {
    'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
        require('lualine').setup({
            options = {
                theme = 'dracula'
            },
            sections = {
                -- Replace with abs path
                lualine_c = {{
                    'filename',
                    path = 3
                }},
                lualine_z = {{
                    'lsp_status',
                    icon = '', -- f013
                    symbols = {
                        -- Standard unicode symbols to cycle through for LSP progress:
                        spinner = {'⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'},
                        -- Standard unicode symbol for when LSP is done:
                        done = '✓',
                        -- Delimiter inserted between LSP names:
                        separator = ' '
                    },
                    -- List of LSP names to ignore (e.g., `null-ls`):
                    ignore_lsp = {}
                }}
            }
        })
    end
}
