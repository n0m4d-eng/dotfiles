require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>ta", function()
  require("custom.tag_picker").insert_tag()
end,{desc = "Add tag"})


map("n", "<leader>pa", function()
  require("custom.paste-image").setup()
end,{desc = "Paste Image"})
