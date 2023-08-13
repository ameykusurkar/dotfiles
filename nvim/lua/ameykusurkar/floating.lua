M = {}

M.run = function(command, opts)
  opts = opts or {}
  opts.close_on_exit = opts.close_on_exit or false
  opts.interactive = opts.interactive or false

  local term_buf = vim.api.nvim_create_buf(false, true)
  local ui = vim.api.nvim_list_uis()[1]

  local term_width = math.floor(ui.width / 2.5)
  local term_height = math.floor(ui.height / 3)

  local term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = 'editor',
    width = term_width,
    height = term_height,
    col = ui.width - term_width - 3,
    row = 1,
    style = 'minimal',
    border = 'rounded',
  })

  local close = function()
    vim.api.nvim_win_close(term_win, true)
    vim.api.nvim_buf_delete(term_buf, { force = true })
  end

  if not (opts.close_on_exit or opts.interactive) then
    vim.keymap.set('n', '<ESC>', close, { buffer = term_buf })
  end

  vim.fn.termopen(command, {
    on_exit = function()
      if opts.close_on_exit then
        close()
      end
    end,
  })

  if opts.interactive then
    vim.cmd('startinsert')
  else
    vim.cmd('norm G')
  end
end

M.readonly = function(command)
  M.run(command, { close_on_exit = false, interactive = false })
end

M.console = function(command)
  M.run(command, { close_on_exit = true, interactive = true })
end

M.shell = function()
  M.console('$SHELL')
end

M.rspec_current_line = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local current_line_number = vim.fn.line('.')
  local result = filename .. ":" .. current_line_number
  M.readonly('bundle exec rspec ' .. result)
end

M.rspec = function()
  M.readonly('bundle exec rspec %')
end

vim.api.nvim_create_user_command('FloatingShell', M.shell, {})

return M
