return {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        -- Avoid session clutter!
        auto_create = false,
        auto_save = true,
        auto_delete_empty_sessions = false, -- don't delete sessions just because no named buffers are open
        legacy_cmds = false,                -- removes duplicate "Autosession" (lowercase s) command
        cwd_change_handling = true, -- save/restore sessions on :cd, keeps rust-toolchain.toml etc. correct
        post_cwd_changed_cmds = {
            function()
                require("lualine").refresh()
            end,
        },
    },
    keys = { -- "s" for "session"
        {
            "<leader>ss",
            "<cmd>AutoSession search<cr>",
            desc = "Search sessions"
        } }
}
