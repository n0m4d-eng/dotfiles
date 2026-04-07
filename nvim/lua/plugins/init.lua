return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },


-- templater plugin
{'glepnir/template.nvim', cmd = {'Template','TemProject'}, config = function()
    require('template').setup({
        -- config in there
        temp_dir = '~/Desktop/n0m4d_files/01_notes/templates/'
    })
end},

-- markdown preview
{
    'brianhuster/live-preview.nvim',
    opts = {}, -- Required to call setup()
    cmd = { "LivePreview", "LivePreviewStop", "LivePreviewToggle" },
    ft = { "markdown", "html", "svg" },
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
},

-- lazygit
{
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  }
}
