vim.scriptencoding = "utf-8"

vim.cmd("language en_US.UTF-8")

-- Auto reload files changed outside of Neovim
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})

-- LINE NUMBER
vim.opt.number = true

-- KEY MAPPING
vim.g.mapleader = " "
vim.api.nvim_set_keymap("i", "jj", "<esc>", { noremap = true })
vim.api.nvim_set_keymap("i", "kk", "<esc>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-h>", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c>", "", {
  noremap = true,
  silent = true,
  callback = function() require("mini.bufremove").delete(0, false) end,
})
vim.api.nvim_set_keymap("n", "<C-s>", ":w<CR>", { noremap = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })

-- INDENTATION AND FORMATTING
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true

-- SEARCH AND HIGHLIGHTING
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- CLIPBOARD AND BACKUP
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- MOUSE AND SPELLCHECK
vim.opt.mouse = "a"
vim.opt.spell = false
vim.opt.spelllang = { "en", "cjk" }

-- ENABLE TRUE COLOR SUPPORT
if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1

-- HOVER
vim.opt.updatetime = 500
