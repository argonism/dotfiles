-- LSP configuration for Neovim 0.11+

local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- キーマップ設定
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
  vim.keymap.set('n', '<leader>d', function()
    vim.diagnostic.open_float({
      focusable = false,
      close_events = { "CursorMoved", "BufHidden", "InsertCharPre" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    })
  end, opts)
  vim.keymap.set('n', '<leader>t', function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local has_hover = false
    for _, client in pairs(clients) do
      if client.server_capabilities.hoverProvider then
        has_hover = true
        break
      end
    end

    if has_hover then
      vim.lsp.buf.hover()
    end
  end, opts)

  -- Enable document highlight
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = "lsp_document_highlight",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

-- Function to check if a floating dialog exists and if not
-- then check for diagnostics or show hover info under the cursor
function OpenDiagnosticOrHoverIfNoFloat()
  for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(winid).zindex then
      return
    end
  end

  -- Check if we're in a buffer with LSP attached
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return
  end

  -- Get diagnostics at cursor position
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })

  if #diagnostics > 0 then
    -- Show diagnostics if available
    vim.diagnostic.open_float({
      scope = "cursor",
      focusable = false,
      close_events = {
        "CursorMoved",
        "CursorMovedI",
        "BufHidden",
        "InsertCharPre",
        "WinLeave",
      },
    })
  else
    -- Show hover info (type information) if no diagnostics
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local has_hover = false
    for _, client in pairs(clients) do
      if client.server_capabilities.hoverProvider then
        has_hover = true
        break
      end
    end

    if has_hover then
      vim.lsp.buf.hover()
    end
  end
end

-- Show diagnostics or hover info when cursor is held
vim.api.nvim_create_augroup("lsp_info_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
  pattern = "*",
  command = "lua OpenDiagnosticOrHoverIfNoFloat()",
  group = "lsp_info_hold",
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
})

local lsp_dir = vim.fn.stdpath('config') .. '/lsp'
if vim.fn.isdirectory(lsp_dir) == 1 then
  for _, file in ipairs(vim.fn.readdir(lsp_dir)) do
    if file:match('%.lua$') then
      local filepath = lsp_dir .. '/' .. file
      local config = dofile(filepath)
      if config and config.name then
        local setup_config = {
          on_attach = on_attach,
        }
        
        -- Override defaults with provided configs
        if config.cmd then
          setup_config.cmd = config.cmd
        end
        
        if config.filetypes then
          setup_config.filetypes = config.filetypes
        end
        
        if config.root_markers then
          setup_config.root_dir = function(fname)
            local found = vim.fs.find(config.root_markers, { 
              path = tostring(fname), 
              upward = true 
            })
            return found[1] and vim.fs.dirname(found[1]) or nil
          end
        end
        
        if config.settings then
          setup_config.settings = config.settings
        end
        
        vim.lsp.config(config.name, setup_config)
        vim.lsp.enable(config.name)
      end
    end
  end
end
