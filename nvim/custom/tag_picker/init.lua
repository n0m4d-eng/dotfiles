local M = {}

M.insert_tag = function()
  local ok, telescope = pcall(require, "telescope")
  if not ok then 
    vim.notify("Telescope not found!", vim.log.levels.ERROR)
    return 
  end

  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local conf = require("telescope.config").values
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  -- Using long brackets [=[ ... ]=] means we do not need to escape anything.
  -- This command is now exactly as it would be typed in a terminal.
  local cmd = [=[grep -rh "tags: \[" . --include="*.md" 2>/dev/null | sed "s/.*\[//; s/\].*//" | tr "," "\n" | sed "s/^[[:space:]]*//; s/[[:space:]]*$//" | sort -u]=]
  
  local handle = io.popen(cmd)
  if not handle then return end
  local result = handle:read("*a")
  handle:close()

  local tags = {}
  for tag in result:gmatch("[^\r\n]+") do
    if tag ~= "" then table.insert(tags, tag) end
  end

  pickers.new({}, {
    prompt_title = "Tags Database",
    finder = finders.new_table { results = tags },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          -- Insert the tag at the cursor
          vim.api.nvim_put({ selection[1] }, "c", true, true)
        end
      end)
      return true
    end,
  }):find()
end

return M
