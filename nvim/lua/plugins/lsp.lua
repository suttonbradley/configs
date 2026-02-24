return { {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = { "clangd", "lua_ls", "powershell_es", "ruff", "taplo", "yamlls" },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}, {
    "neovim/nvim-lspconfig",
    config = function()
        vim.lsp.config['lua_ls'] = {
            cmd = { 'lua-language-server' },
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim' }
                    }
                }
            }
        }
        vim.lsp.config['clangd'] = {
            cmd = { 'clangd' }
        }
        vim.lsp.config['powershell_es'] = {
            cmd = { 'PowerShellEditorServices' }
        }
        vim.lsp.config['ruff'] = {
            cmd = { 'ruff', 'server' }
        }
        vim.lsp.config['taplo'] = {
            cmd = { 'taplo', 'lsp', 'stdio' }
        }
        vim.lsp.config['yamlls'] = {
            cmd = { 'yaml-language-server', '--stdio' }
        }
        vim.lsp.config['nushell'] = {
            -- NOTE: LSP is built into the nu binary, not installed via Mason
            cmd = { 'nu', '--lsp' },
            filetypes = { 'nu' },
        }

        -- nushell is not mason-managed, enable manually
        vim.lsp.enable('nushell')

        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
        vim.keymap.set('n', 'gd', function()
            vim.lsp.buf.declaration()
            vim.defer_fn(function()
                vim.cmd('normal! zz')
            end, 50) -- defer 50ms
        end, {
            noremap = true, silent = true
        })
        vim.keymap.set('n', 'gD', function()
            vim.lsp.buf.definition()
            vim.defer_fn(function()
                vim.cmd('normal! zz')
            end, 50) -- defer 50ms
        end, {
            noremap = true, silent = true
        })
        vim.keymap.set('n', 'gu', '<C-T>zz', {
            noremap = true
        })
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, {
            noremap = true
        })
        vim.keymap.set('n', '<leader>fm', vim.lsp.buf.format, {
            noremap = true
        })

        -- If LSP is attached, format on buffer write
        vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function()
                local mode = vim.api.nvim_get_mode().mode
                local filetype = vim.bo.filetype
                if vim.bo.modified == true and mode == 'n' and filetype ~= "oil" and filetype ~= "toml" then
                    vim.cmd('lua vim.lsp.buf.format()')
                else
                end
            end
        })

        vim.lsp.inlay_hint.enable(true)
    end
} }
