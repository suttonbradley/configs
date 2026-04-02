return { {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    config = function()
        -- Ensure rust-analyzer is installed on the stable toolchain (not the
        -- project-pinned toolchain, which may bundle an outdated rust-analyzer).
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "rust",
            once = true,
            callback = function()
                -- TODO: remove "--toolchain stable" when work is on a new enough Rust toolchain (see below)
                vim.fn.jobstart({ "rustup", "component", "add", "rust-analyzer", "--toolchain", "stable" })
            end,
        })

        vim.g.rustaceanvim = {
            server = {
                -- NOTE: uses stable rust-analyzer because some too out of date for setTest
                -- TODO: remove entire line when work is on a new enough Rust toolchain (1.82+) to use cfg.setTest
                cmd = { "rustup", "run", "stable", "rust-analyzer" },
                default_settings = {
                    ['rust-analyzer'] = {
                        cfg = {
                            setTest = false,
                        },
                        cargo = {
                            -- TODO: use project-local features? could just modify features via the RustFeatures command below
                            features = { "eve" },
                        },
                    }
                },
                capabilities = {
                    textDocument = {
                        completion = {
                            completionItem = {
                                snippetSupport = false,
                            },
                        }
                    },
                },
            },
        }

        vim.api.nvim_create_user_command('RustFeatures', function(opts)
            if opts.args == '' then
                local features = vim.deepcopy(vim.g.rustaceanvim.server.default_settings['rust-analyzer'].cargo.features)
                local msg = #features == 0 and 'default' or table.concat(features, ', ')
                vim.notify('rust-analyzer features: ' .. msg, vim.log.levels.INFO)
            else
                local features = opts.args == 'default' and {} or vim.tbl_filter(function(f) return f ~= '' end,
                    vim.split(opts.args, ',', { trimempty = true }))
                local cfg = vim.deepcopy(vim.g.rustaceanvim)
                cfg.server.default_settings['rust-analyzer'].cargo.features = features
                vim.g.rustaceanvim = cfg
                require('rustaceanvim.config.internal').server.default_settings['rust-analyzer'].cargo.features =
                    features
                local msg = #features == 0 and '(none)' or table.concat(features, ', ')
                if vim.fn.exists(':RustAnalyzer') ~= 2 then
                    vim.notify('rust-analyzer features set to: ' .. msg .. ' (open a .rs file to start LSP)',
                        vim.log.levels.WARN)
                    return
                end
                vim.notify('rust-analyzer features set to: ' .. msg .. ', restarting...', vim.log.levels.INFO)
                vim.cmd('RustAnalyzer restart')
                vim.defer_fn(function()
                    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                        if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].filetype == 'rust' then
                            vim.lsp.semantic_tokens.force_refresh(bufnr)
                        end
                    end
                end, 5000)
            end
        end, { nargs = '?' })
    end,
} }
