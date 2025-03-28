return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            {
                "<C-p>",
                function() require("telescope.builtin").find_files() end,
                desc = "Find files",
            },
            {
                -- Actually <C-/>, but that's not what it sends so ¯\_(ツ)_/¯
                "",
                function() require("telescope.builtin").live_grep() end,
                desc = "Live grep",
            }
        },
        -- change some options
        opts = {
            defaults = {
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
                winblend = 0,
            },
        },
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    }
                }
            }
            require("telescope").load_extension("ui-select")
        end
    },
}
