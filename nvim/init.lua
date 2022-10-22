---- GENERAL ----
vim.opt.number = true -- Show line numbers
vim.opt.cursorline = true -- Highlights the line that the cursor is on
vim.opt.timeoutlen = 300 -- How long to wait mid key sequence before timing out

vim.g.mapleader = ","

local function nnoremap(shortcut, command)
  vim.keymap.set("n", shortcut, command, { noremap = true })
end

local function vnoremap(shortcut, command)
  vim.keymap.set("v", shortcut, command, { noremap = true })
end

---- INDENTATION ----
vim.opt.tabstop = 2 -- Width of TAB character
vim.opt.softtabstop = 2 -- Width of <TAB> key
vim.opt.shiftwidth = 2 -- Width for formatting (>, =)
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smarttab = true -- Use shiftwidth when inserting a tab in front of a line
vim.opt.shiftround = true -- Round indent to multiple of shiftwidth

vim.opt.backspace = "indent,eol,start" -- Allow backspace over indent, eol, start

---- PLUGINS ----
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  --- LSP
  use 'neovim/nvim-lspconfig'

  --- Completion
  use 'hrsh7th/nvim-cmp' -- Main completion engine
  use 'hrsh7th/cmp-buffer' -- Source for neovim buffers
  use 'hrsh7th/cmp-path' -- Source for file paths
  use 'hrsh7th/cmp-nvim-lua' -- Source for neovim Lua API
  use 'hrsh7th/cmp-nvim-lsp' -- Source for built-in LSP
  use 'saadparwaiz1/cmp_luasnip' -- Source for LuaSnip

  --- Snippets
  use { "L3MON4D3/LuaSnip", tag = "v1.*" }
  -- use 'rafamadriz/friendly-snippets'

  --- Appearance
  use 'itchyny/lightline.vim' -- Status line appearance
  use 'chriskempson/base16-vim' -- Colorschemes
  use {
    'j-hui/fidget.nvim',
    config = function() require("fidget").setup() end,
  }

  --- Productivity
  use 'tpope/vim-commentary' -- Plug Comment stuff out
  use 'lewis6991/gitsigns.nvim' -- Git plugin
  use 'tpope/vim-fugitive' -- Git plugin, TODO: Replace with gitsigns
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup()
    end,
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  }

  -- Open files in github
  use 'tyru/open-browser.vim'
  use 'tyru/open-browser-github.vim'

  -- Languages
  use 'dag/vim-fish'
end)

---- APPEARANCE ----
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.background = "dark"
vim.api.nvim_command("colorscheme base16-gruvbox-dark-hard")

vim.opt.showmode = false -- Don't show mode in status line, as lightline does it
vim.opt.laststatus = 2 -- Always show status line
vim.g.lightline = {
  colorscheme = 'seoul256',
  active = {
    left = {
      { 'mode', 'paste' },
      { 'readonly', 'gitbranch', 'filename', 'modified' }
    },
  },
  component_function = {
    -- TODO: Replace with gitsigns plugin if possible
    gitbranch = 'FugitiveHead',
  },
  component = {
    lineinfo = "%{line('.') . '/' . line('$') . ':' . col('.')}",
    filename = "%{expand('%')}",
  },
}

---- SEARCH ----
-- Ignore case unless search has uppercase chars
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Remove highlighting for search
nnoremap(";", ":nohlsearch<CR>")

---- MISCELLANEOUS MAPPINGS ----
nnoremap("<leader>s", ":source ~/.config/nvim/init.lua<CR>")
nnoremap("<leader>v", ":sp ~/.config/nvim/init.lua<CR>")

-- Uppercase word
nnoremap("<leader>u", "gUiw")

nnoremap("<leader>n", ":NvimTreeToggle<CR>")

nnoremap("<leader>m", ":lua require('gitsigns').blame_line({full=true})<CR>")

nnoremap("<leader>g", ":OpenGithubFile<CR>")
vnoremap("<leader>g", ":OpenGithubFile<CR>")

nnoremap("<leader>fd", function() require('telescope.builtin').git_files() end)
nnoremap("<leader>fb", function()
  require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({}))
end)

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
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true })
  end
})

---- COMPLETION ----
vim.opt.completeopt = "menu,menuone,noselect"

local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
  }),
  sources = cmp.config.sources({
    -- This determines the order in which sources appear in suggestions
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer', keyword_length = 3 },
  }),
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
})

---- SNIPPETS ----
vim.api.nvim_command("imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'")

vim.keymap.set("n", "<leader><leader>s", ":source ~/.config/nvim/plugin/luasnip.lua<CR>")

---- LSP ----
local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local on_attach = function(_, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<leader>fi', function() vim.lsp.buf.format { async = true } end, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
end

lspconfig.rust_analyzer.setup({ capabilities = capabilities, on_attach = on_attach })

lspconfig.solargraph.setup({ capabilities = capabilities, on_attach = on_attach })

lspconfig.sumneko_lua.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
})

---- TELESCOPE ----
require('telescope').setup({
  defaults = {
    prompt_prefix = "❯ ",
    selection_caret = "❯ ",
  },
})
require('telescope').load_extension('fzf')
