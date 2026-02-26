local M = {}

local function paste_image()
  -- 1. Get current file path and directory
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    print("Error: Not in a file.")
    return
  end
  local current_dir = vim.fn.fnamemodify(current_file, ':h')

  -- 2. Define the .images directory
  local img_dir = current_dir .. '/.images'

  -- 3. Create the .images directory if it doesn't exist
  if vim.fn.isdirectory(img_dir) == 0 then
    vim.fn.mkdir(img_dir, 'p')
  end

  -- 4. Setup file names
  local file_name = 'img_' .. os.date('%Y%m%d_%H%M%S') .. '.png'
  local file_path = img_dir .. '/' .. file_name

  -- 5. Use macOS built-in tool to save clipboard image
  local cmd = string.format("pngpaste %s", vim.fn.shellescape(file_path))
  vim.fn.system(cmd)

  -- 6. Check if file was actually created and insert relative link
  if vim.fn.filereadable(file_path) == 1 and vim.fn.getfsize(file_path) > 0 then
    -- Calculate relative path from current file to the image
    local rel_path = '.images/' .. file_name
    local link = string.format('![](%s)', rel_path)
    vim.api.nvim_put({ link }, 'c', true, true)
  else
    print("Error: No image found in clipboard or failed to save.")
  end
end

function M.setup()
  vim.api.nvim_create_user_command('PasteImage', paste_image, {})
end

return M
