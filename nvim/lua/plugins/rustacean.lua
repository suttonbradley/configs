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
                            -- TODO: use project-local features
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
    end,
} }
