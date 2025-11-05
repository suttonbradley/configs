return {{
    "nvim-telescope/telescope.nvim",
    dependencies = {'nvim-lua/plenary.nvim'},
    keys = {{
        "<leader>ff",
        function()
            require("telescope.builtin").find_files()
        end,
        desc = "Find files"
    }, {
        "<leader>fg",
        function()
            require("telescope.builtin").live_grep()
        end,
        desc = "Live grep"
    }},
    -- change some options
    opts = {
        defaults = {
            layout_strategy = "horizontal",
            layout_config = {
                prompt_position = "top"
            },
            sorting_strategy = "ascending",
            winblend = 0,
            mappings = {
                -- NOTE: if these don't work you need the following in
                -- the "actions" array of your windows terminal config
                -- {
                --     "id": "User.copy.644BA8F2",
                --     "keys": "ctrl+c"
                -- },
                -- {
                --     "id": "User.splitPane.A6751878",
                --     "keys": "alt+shift+d"
                -- }

                i = {
                    ["<s-cr>"] = "file_vsplit",
                    ["<c-cr>"] = "file_split"
                },
                n = {
                    ["<s-cr>"] = "file_vsplit",
                    ["<c-cr>"] = "file_split"
                }
            }
        }
    }
}, {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
        require("telescope").setup {
            extensions = {
                ["ui-select"] = {require("telescope.themes").get_dropdown {}}
            }
        }
        require("telescope").load_extension("ui-select")
    end
}}
