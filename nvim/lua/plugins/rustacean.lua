return { {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
    config = function()
        -- Ensure rust-analyzer is installed for the current toolchain
        -- (respects rust-toolchain.toml via cwd). Idempotent; no-ops if already present.
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "rust",
            once = true,
            callback = function()
                vim.fn.jobstart({ "rustup", "component", "add", "rust-analyzer" })
            end,
        })

        vim.g.rustaceanvim = {
            server = {
                default_settings = {
                    ['rust-analyzer'] = {
                        cargo = {
                            features = "all",
                        },
                        checkOnSave = {
                            command = "clippy",
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
