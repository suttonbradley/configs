-- From harpoon README: https://github.com/ThePrimeagen/harpoon/tree/harpoon2?tab=readme-ov-file#basic-setup
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
-- Done below in telescope section
vim.keymap.set("n", "<leader>hp", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    { desc = "Open harpoon window" })

-- Edited by Sutton for qwerty;
-- A bit weird, but wanted C-h and C-l to be the same as the vim bindings (L/R)
--     and the most frequent files to be in the home row
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-i>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<C-o>", function() harpoon:list():select(5) end)
vim.keymap.set("n", "<C-p>", function() harpoon:list():select(6) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-y>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():next() end)

-- Highlight current file in list
local harpoon_extensions = require("harpoon.extensions")
harpoon:extend(harpoon_extensions.builtins.highlight_current_file())
