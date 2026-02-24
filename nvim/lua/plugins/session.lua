return {
    'rmagatti/auto-session',
    lazy = false,

    -- "nvim" opens the last session; "nvim ." or "nvim <file_or_dir>" opens session-less
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
        auto_create = false,
        auto_save = true,
        auto_restore_last_session = true,    -- restore last session if no session for cwd exists
        auto_delete_empty_sessions = false, -- don't delete sessions just because no named buffers are open
        legacy_cmds = false,                -- removes duplicate "Autosession" (lowercase s) command
        cwd_change_handling = true, -- save/restore sessions on :cd, keeps rust-toolchain.toml etc. correct
        session_lens = {
            picker_opts = {
                initial_mode = "normal",
            },
        },
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
