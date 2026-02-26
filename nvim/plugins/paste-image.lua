return {
  {
    dir = vim.fn.stdpath("config") .. "/lua/custom/paste-image",
    event = "VeryLazy",
    config = function()
      require("custom.paste-image").setup()
    end,
  },
}
