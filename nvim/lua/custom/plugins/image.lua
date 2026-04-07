 -- lua/custom/plugins/image.lua
    2     return {
    3       {
    4         '3rd/image.nvim',
    5         -- Ensure this plugin loads after filetype detection for Markdown
    6         ft = { 'markdown', 'vimwiki' }, -- You can add other filetypes where you want image preview
    7
    8         config = function()
    9           require('image').setup({
   10             backend = 'iterm2', -- *** Crucial for WezTerm ***
   11             integrations = {
   12                 markdown = {
   13                     enabled = true,
   14                     -- You can customize markdown-specific options here, e.g.,
   15                     -- render_type = 'inline', -- 'float' for floating window, 'inline' for above/below text
   16                 },
   17                 -- If you use Telescope and want image previews there:
   18                 -- telescope = {
   19                 --     enabled = true,
   20                 -- },
   21             },
   22             -- General image display options:
   23             -- max_width = 100, -- Maximum width of displayed images in characters
   24             -- max_height = 50, -- Maximum height of displayed images in lines
   25             -- editor_width_percent = 0.8, -- Use 80% of editor width for preview
   26           })
   27         end,
   28       },
   29     }
