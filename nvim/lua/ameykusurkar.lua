local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function find_files_for_selection(prompt_bufnr, _)
  actions.select_default:replace(function()
    actions.close(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    require('telescope.builtin').find_files({ cwd = selection[1] })
  end)
  return true
end

M = {}

M.find_files_in_dirs = function(opts)
  local ff_opts = {
    attach_mappings = find_files_for_selection,
    find_command = { "find", ".", "-type", "d", "-maxdepth", opts.maxdepth, "-mindepth", opts.mindepth },
    search_dirs = opts.dirs,
  }
  require('telescope.builtin').find_files(ff_opts)
end

return M
