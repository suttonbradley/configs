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
    }
}
