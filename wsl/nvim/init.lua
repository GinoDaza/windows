-- ============================================================================
-- Minimal Neovim Configuration
-- Location: ~/.config/nvim/init.lua
-- Works standalone in WSL & Linux
-- ============================================================================

if vim.loader then
  vim.loader.enable()
end

-- ----------------------------------------------------------------------------
-- 1. Essential Options
-- ----------------------------------------------------------------------------
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
-- 2. Helix Mappings & Useful Shortcuts
-- ----------------------------------------------------------------------------
local map = vim.keymap.set

-- Press Esc to clear search highlight
map('n', '<esc>', '<cmd>nohlsearch<cr>')

-- Helix-style bindings
map({ 'n', 'v', 'x' }, 'U', '<c-r>', { desc = 'Redo' })
map({ 'n', 'v', 'x' }, 'gh', '^', { desc = 'Go to start of line' })
map({ 'n', 'v', 'x' }, 'gl', '$', { desc = 'Go to end of line' })
map({ 'n', 'v', 'x' }, 'gH', 'g^', { desc = 'Go to wrapped line start' })
map({ 'n', 'v', 'x' }, 'gL', 'g$', { desc = 'Go to wrapped line end' })

-- ----------------------------------------------------------------------------
-- 3. Useful Autocommands (Built-in)
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
