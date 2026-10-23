-- ============================================================================
-- Minimal Neovim Configuration
-- Location: ~/.config/nvim/init.lua
-- Works standalone in WSL & Linux
-- ============================================================================

if vim.loader then
  vim.loader.enable()
end

-- Silence missing treesitter parser errors gracefully
local ts_start = vim.treesitter.start
vim.treesitter.start = function(buf, lang)
  pcall(ts_start, buf, lang)
end

-- ----------------------------------------------------------------------------
-- 1. Essential Options
-- ----------------------------------------------------------------------------
vim.g.mapleader = ' '         -- Space as Leader key

-- Disable netrw (replaced by mini.files for directories)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.number = true         -- Show line numbers
vim.opt.cursorline = true     -- Highlight current line
vim.opt.wrap = false          -- Don't wrap long lines by default
vim.opt.scrolloff = 4         -- Keep 4 lines visible above/below cursor

-- Indentation (4 spaces)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true     -- Case-insensitive search...
vim.opt.smartcase = true      -- ...unless capital letters are used
vim.opt.hlsearch = true       -- Highlight search matches

-- Undo & Performance
vim.opt.undofile = true       -- Save undo history to file
vim.opt.swapfile = false      -- Disable swap files

-- Whitespace display
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- ----------------------------------------------------------------------------
-- 2. Plugin Manager (lazy.nvim)
-- ----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash Jump' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
    },
  },
  {
    'echasnovski/mini.icons',
    opts = {},
    config = function(_, opts)
      local ok, icons = pcall(require, 'mini.icons')
      if ok then
        icons.setup(opts)
        icons.mock_nvim_web_devicons()
      end
    end,
  },
  {
    'echasnovski/mini.files',
    lazy = false,
    opts = {
      options = {
        use_as_default_explorer = true,
        permanent_delete = false,  -- Move deleted files to ~/.local/share/nvim/mini.files/trash
      },
    },
  },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = true,
    opts = {
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      },
    },
    init = function()
      vim.cmd.colorscheme('gruvbox')
    end,
  },
})

-- ----------------------------------------------------------------------------
-- 3. Mappings & Shortcuts
-- ----------------------------------------------------------------------------
local map = vim.keymap.set

-- Press Esc to clear search highlight
map('n', '<esc>', '<cmd>nohlsearch<cr>')

-- Save file (Ctrl + S)
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<cr>', { desc = 'Save file' })

-- Move lines up / down (Alt + j / Alt + k)
map('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
map('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
map('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
map('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Fast movement (5 lines down/up with Ctrl + j/k)
map({ 'n', 'v' }, '<C-j>', '5j', { desc = 'Move 5 lines down' })
map({ 'n', 'v' }, '<C-k>', '5k', { desc = 'Move 5 lines up' })

-- Helix-style bindings
map({ 'n', 'v', 'x' }, 'U', '<c-r>', { desc = 'Redo' })
map({ 'n', 'v', 'x' }, 'gh', '^', { desc = 'Go to start of line' })
map({ 'n', 'v', 'x' }, 'gl', '$', { desc = 'Go to end of line' })
map({ 'n', 'v', 'x' }, 'gH', 'g^', { desc = 'Go to wrapped line start' })
map({ 'n', 'v', 'x' }, 'gL', 'g$', { desc = 'Go to wrapped line end' })

-- Space e (mini.files) and Space t (floating terminal) toggle each other
local term = { buf = nil, win = nil }

local function term_is_open()
  return term.win and vim.api.nvim_win_is_valid(term.win)
end

local function close_term()
  if term_is_open() then
    vim.api.nvim_win_close(term.win, true)
  end
end

local function close_files()
  local ok, mini = pcall(require, 'mini.files')
  if ok then
    mini.close()
  end
end

map('n', '<leader>e', function()
  -- Terminal buffers have a term:// name, so use the image path instead
  local path = vim.b.image_file or vim.api.nvim_buf_get_name(0)
  if vim.bo.buftype == 'terminal' and not vim.b.image_file then
    path = nil
  end
  close_term()
  local ok, mini = pcall(require, 'mini.files')
  if ok then
    mini.open(path, true)
  end
end, { desc = 'Open Mini Files' })

-- Space e also closes mini.files from inside the explorer
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    map('n', '<leader>e', close_files, { buffer = args.data.buf_id, desc = 'Close Mini Files' })
  end,
})

map('n', '<leader>t', function()
  if term_is_open() then
    close_term()
    return
  end
  close_files()
  local w, h = math.floor(vim.o.columns * 0.8), math.floor(vim.o.lines * 0.8)
  if not (term.buf and vim.api.nvim_buf_is_valid(term.buf)) then
    term.buf = vim.api.nvim_create_buf(false, true)
    map('n', 'q', close_term, { buffer = term.buf, desc = 'Close floating terminal' })
  end
  term.win = vim.api.nvim_open_win(term.buf, true, {
    relative = 'editor', width = w, height = h,
    col = math.floor((vim.o.columns - w) / 2),
    row = math.floor((vim.o.lines - h) / 2),
    style = 'minimal', border = 'rounded',
  })
  if vim.bo[term.buf].buftype ~= 'terminal' then
    vim.fn.termopen(vim.o.shell)
  end
  vim.cmd.startinsert()
end, { desc = 'Toggle floating terminal' })

-- Esc Esc leaves terminal mode
map('t', '<esc><esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

-- ----------------------------------------------------------------------------
-- 4. Useful Autocommands (Built-in)
-- ----------------------------------------------------------------------------

-- Briefly highlight text when copying (yank)
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yanked text',
  callback = function()
    vim.hl.on_yank({ timeout = 250 })
  end,
})

-- Remove trailing whitespaces on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[:%s/\s\+$//e]],
})

-- Show images small in a terminal buffer using chafa
vim.api.nvim_create_autocmd('BufReadCmd', {
  desc = 'Preview images with chafa',
  pattern = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.bmp' },
  callback = function(ev)
    local file = vim.fn.fnamemodify(ev.file, ':p')
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = 'no'
    vim.wo.cursorline = false
    local w, h = vim.api.nvim_win_get_width(0), vim.api.nvim_win_get_height(0)
    vim.b.image_file = file
    vim.api.nvim_create_autocmd('TermClose', {
      buffer = ev.buf,
      once = true,
      callback = function()
        -- Remove the "[Process exited 0]" line
        vim.defer_fn(function()
          if not vim.api.nvim_buf_is_valid(ev.buf) then
            return
          end
          local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
          for i = #lines, 1, -1 do
            if lines[i]:match('^%[Process exited %d+%]$') then
              vim.bo[ev.buf].modifiable = true
              vim.api.nvim_buf_set_lines(ev.buf, i - 1, i, false, {})
              vim.bo[ev.buf].modifiable = false
              break
            end
          end
        end, 50)
      end,
    })
    vim.fn.termopen({
      'chafa',
      '--view-size=' .. w .. 'x' .. h,
      '--size=' .. math.floor(w * 0.75) .. 'x' .. math.floor(h * 0.75),
      '--work=5',
      '--scale=1.0',
      '--align=mid,mid',
      file,
    })
  end,
})
