return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle focus=false win.position=right<cr>",              desc = "Diagnostics (Trouble)" },
        { "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0 focus=false win.position=right<cr>", desc = "Buffer Diagnostics (Trouble)" },
    },
}
