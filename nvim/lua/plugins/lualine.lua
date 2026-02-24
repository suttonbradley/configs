return {
    'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
        require('lualine').setup({
            options = {
                theme = 'dracula'
            },
            sections = {
                lualine_c = {
                    function()
                        local session = require("auto-session.lib").current_session_name(true)
                        local filename = vim.fn.expand("%:.")  -- relative to cwd
                        if session and session ~= "" then
                            return session .. " | " .. filename
                        end
                        return filename
                    end,
                },
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
            },
            inactive_sections = {
                lualine_c = {{
                    'filename',
                    path = 3
                }}
            }
        })
    end
}
