M = {}

local state = {
	window = -1,
	buffer = -1,
}

local function create_floating_window(opts)
	if vim.api.nvim_win_is_valid(state.window) then
		print("[ERROR] Floating window already open")
		return
	end

	opts = opts or {}

	local buffer = -1
	if vim.api.nvim_buf_is_valid(opts.buffer) then
		buffer = opts.buffer
	else
		buffer = vim.api.nvim_create_buf(false, true)
	end

	local term_width = math.floor(vim.o.columns / 2)
	local term_height = vim.o.lines - 4

	local term_win = vim.api.nvim_open_win(buffer, true, {
		relative = "editor",
		width = term_width,
		height = term_height,
		col = vim.o.columns - term_width - 3,
		row = 0,
		style = "minimal",
		border = "rounded",
	})

	return { buffer = buffer, window = term_win }
end

M.toggle = function()
	if vim.api.nvim_win_is_valid(state.window) then
		vim.api.nvim_win_hide(state.window)
	else
		local new_state = create_floating_window({ buffer = state.buffer })
		if not new_state then
			return
		end
		if new_state.buffer ~= state.buffer then
			vim.cmd.terminal()
		end

		vim.cmd.startinsert()

		state = new_state
	end
end

return M
