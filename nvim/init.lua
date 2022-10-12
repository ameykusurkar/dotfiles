---- GENERAL ----

vim.opt.number = true -- Show line numbers
vim.opt.cursorline = true -- Highlights the line that the cursor is on
vim.opt.timeoutlen = 300 -- How long to wait mid key sequence before timing out

vim.g.mapleader = ","

---- INDENTATION ----

vim.opt.tabstop = 2 -- Width of TAB character
vim.opt.softtabstop = 2 -- Width of <TAB> key
vim.opt.shiftwidth = 2 -- Width for formatting (>, =)
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smarttab = true -- Use shiftwidth when inserting a tab in front of a line
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth

vim.opt.backspace = "indent,eol,start" -- Allow backspace over indent, eol, start

function nnoremap(shortcut, command)
  vim.api.nvim_set_keymap( "n", shortcut, command, { noremap = true })
end

---- PLUGINS ----
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  --- Productivity
  use 'tpope/vim-commentary' -- Plug Comment stuff out
  use 'lewis6991/gitsigns.nvim' -- Git plugin
end)

---- APPEARANCE ----

vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.background = "dark"

vim.opt.showmode = false -- Don't show mode in status line, as lightline does it
vim.opt.laststatus = 2 -- Always show status line

---- SEARCH ----

-- Ignore case unless search has uppercase chars
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Remove highlighting for search
nnoremap(";", ":nohlsearch<CR>")

---- MISCELLANEOUS MAPPINGS ----

nnoremap("<leader>s", ":source ~/.config/nvim/init.lua<CR>")

-- Uppercase word
nnoremap("<leader>u", "gUiw")

-- Move lines up/down
nnoremap("<C-J>", "ddp")
nnoremap("<C-K>", "kddpk")

-- Insert a clear newline (if inside a comment, the editor might automatically
-- add the starting characters) 
nnoremap("<CR>", "o<Esc>D")

---- GITSIGNS ----

require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})
  end
})
