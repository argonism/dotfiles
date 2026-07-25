vim.lsp.enable({
  -- nvim-lspconfig で"lua_ls"という名前で設定したプリセットが読まれる
  -- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
  "lua_ls",
  -- 他の言語サーバーの設定
  -- "gopls",
  "pyright",
  "rust_analyzer",
  "tsserver",
})

-- 言語サーバーがアタッチされた時に呼ばれる
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("my.lsp", {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local buf = args.buf


    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { noremap = true, silent = true, buffer = buf })

    -- デフォルトで設定されている言語サーバー用キーバインドに設定を追加する
    -- See https://neovim.io/doc/user/lsp.html#lsp-defaults
    -- 言語サーバーのクライアントがLSPで定められた機能を実装していたら設定を追加するという流れ

    if client:supports_method("textDocument/definition") then
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
    end

    if client:supports_method("textDocument/hover") then
      vim.keymap.set("n", "K",
        function() vim.lsp.buf.hover({ border = "single" }) end,
        { buffer = buf, desc = "Show hover documentation" })
    end

    if client:supports_method("textDocument/documentHighlight") then
      vim.keymap.set("n", "<leader>k", function()
        if vim.b.lsp_highlight_active then
          vim.lsp.buf.clear_references()
          vim.b.lsp_highlight_active = false
        else
          vim.lsp.buf.document_highlight()
          vim.b.lsp_highlight_active = true
        end
      end, { buffer = buf, desc = "Toggle reference highlight" })
    end

    -- if client:supports_method("textDocument/completion") then
    --   -- client.server_capabilities.completionProvider.triggerCharacters = chars
    --   -- client.server_capabilities.completionProvider.triggerCharacters =
    --   --     vim.split("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.", "")
    --   vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    -- end

    -- Auto-format ("lint") on save.
    -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
    if not client:supports_method("textDocument/willSaveWaitUntil")
        and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
        end,
      })
    end

    if client:supports_method("textDocument/inlineCompletion") and vim.lsp.inline_completion then
      vim.lsp.inline_completion.enable(true, { bufnr = buf })
      vim.keymap.set("i", "<Tab>", function()
        if not vim.lsp.inline_completion.get() then
          return "<Tab>"
        end
        -- close the completion popup if it's open
        if vim.fn.pumvisible() == 1 then
          return "<C-e>"
        end
      end, {
        expr = true,
        buffer = buf,
        desc = "Accept the current inline completion",
      })
    end
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("diagnostic", {}),
  callback = function()
    -- Skip if a floating window is already open
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(winid).relative ~= "" then
        return
      end
    end

    local lnum = vim.fn.line(".") - 1
    local diags = vim.diagnostic.get(0, { lnum = lnum })
    if #diags > 0 then
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
      return
    end

  end,
})
