local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function find_files_for_selection(prompt_bufnr, _)
	actions.select_default:replace(function()
		actions.close(prompt_bufnr)
		local selection = action_state.get_selected_entry()
		require("telescope.builtin").find_files({ cwd = selection[1] })
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
	require("telescope.builtin").find_files(ff_opts)
end

-- Toggle a single line's checkbox. Returns the modified line, or nil if not a checkbox.
--
-- Lua pattern matching syntax (similar to regex but different):
--   %   - escape character (like \ in regex)
--   %-  - literal hyphen (unescaped - means "zero or more, non-greedy")
--   %[  - literal [ (unescaped [ starts a character class)
--   %]  - literal ]
--
-- So "%- %[ %]" matches the literal string "- [ ]"
--
-- String methods in Lua:
--   line:match(pattern)           - returns the match if found, nil otherwise
--                                   (colon syntax is shorthand for line.match(line, pattern))
--   line:gsub(pattern, repl, n)   - substitute pattern with repl, n times (n=1 means first only)
--                                   returns the new string (strings are immutable in Lua)
local function toggle_line(line)
	if line:match("%- %[ %]") then
		return line:gsub("%- %[ %]", "- [x]", 1)
	elseif line:match("%- %[x%]") then
		return line:gsub("%- %[x%]", "- [ ]", 1)
	end
	return nil
end

-- Normal mode: toggle checkbox on current line
--
-- Neovim API:
--   vim.api.nvim_get_current_line()   - returns the line under the cursor as a string
--   vim.api.nvim_set_current_line(s)  - replaces the current line with string s
M.toggle_checkbox = function()
	local new_line = toggle_line(vim.api.nvim_get_current_line())
	if new_line then
		vim.api.nvim_set_current_line(new_line)
	end
end

-- Visual mode: toggle checkboxes on all lines in the selection
--
-- Visual selection marks:
--   When you exit visual mode, Vim sets two marks:
--     '<  - line/column where visual selection started
--     '>  - line/column where visual selection ended
--
-- Vim functions (accessed via vim.fn):
--   vim.fn.line("'<")      - get line number of mark '<  (selection start)
--   vim.fn.line("'>")      - get line number of mark '>  (selection end)
--   vim.fn.getline(n)      - get contents of line n as a string
--   vim.fn.setline(n, s)   - set line n to string s
--
-- Lua for loop: "for lnum = start, end do" iterates from start to end inclusive
M.toggle_checkbox_visual = function()
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")

	for lnum = start_line, end_line do
		local line = vim.fn.getline(lnum)
		local new_line = toggle_line(line)
		if new_line then
			vim.fn.setline(lnum, new_line)
		end
	end
end

return M
