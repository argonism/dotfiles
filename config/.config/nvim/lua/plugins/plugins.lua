return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.o.background = "light"
      require("gruvbox").setup({
        contrast = "hard",
      })

      -- load the colorscheme here
      vim.cmd([[colorscheme gruvbox]])
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- main ブランチ(rewrite)は configs.setup / ensure_installed / highlight.enable を廃止。
      -- パーサは install() で明示導入し、ハイライトと indent は FileType autocmd で有効化する。
      -- lua/vim/vimdoc/markdown/markdown_inline/c/query は Neovim 本体に組み込み済み
      -- (パーサ+query 同梱)。ここで二重導入すると古い site パーサが同梱 query と衝突するため除外。
      require("nvim-treesitter").install({
        "python", "javascript", "typescript", "tsx",
        "html", "css", "json", "yaml", "rust", "toml", "bash",
      })

      vim.api.nvim_create_autocmd("FileType", {
        desc = "treesitter ハイライトと indent を有効化",
        callback = function(ev)
          -- パーサ未導入の filetype では start が失敗するので握りつぶす(旧 auto_install 相当は無し)
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { mode = "n", "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "NvimTreeをトグルする" },
      { mode = "n", "<C-m>", "<cmd>NvimTreeFocus<CR>", desc = "NvimTreeにフォーカス" },
      { mode = "n", "<leader>e", "<cmd>NvimTreeFindFile<CR>", desc = "NvimTreeで現在のファイルを見つける" },
    },
    config = function()
      require("nvim-tree").setup({
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          local function opts(desc)
            return { desc = "NvimTree: " .. desc, buffer = bufnr, silent = true }
          end
          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.del("n", "M", { buffer = bufnr })
          vim.keymap.set("n", "M", api.node.run.cmd, opts("Run Node Command"))
          vim.keymap.del("n", "L", { buffer = bufnr })
        end
      })
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup {
        options = {
          offsets = {
            { filetype = "NvimTree", text = "File Explorer", highlight = "Directory", separator = true },
          },
          diagnostics = "nvim_lsp",
        },
      }
    end
  },
  {
    'numToStr/Comment.nvim',
  },
  {
    'echasnovski/mini.surround',
    version = '*',
    config = function()
      require('mini.surround').setup()
    end,
  },
  {
    'echasnovski/mini.bufremove',
    version = '*',
    config = function()
      require('mini.bufremove').setup()
    end,
  },
  { 'github/copilot.vim' },
  {
    'HiPhish/rainbow-delimiters.nvim',
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    keys = {
      { "<leader>dm", "<cmd>Noice dismiss<CR>", desc = "Dismiss notifications" },
    },
    config = function()
      require("noice").setup({
        presets = {
          bottom_search = true,         -- use a classic bottom cmdline for search
          command_palette = true,       -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
        },
        messages = {
          view = "mini", -- 通知をnvim-notifyの大きいポップアップではなく右下の控えめな表示に
        },
        notify = {
          view = "mini", -- vim.notify() 経由の通知も同様にmini表示
        },
      })
    end
  },
  { 'akinsho/git-conflict.nvim', version = "*", config = true },
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true
        },
        indent = {
          enable = true
        }
      }
      )
    end
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = { preset = 'default' },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    -- mkdp#util#install() は prebuilt バイナリ頼みで Apple Silicon だと落ちるため npm install で入れる
    build = "cd app && npm install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle Markdown Preview" },
    },
  },
  {
    "karb94/neoscroll.nvim",
    opts = {
      duration_multiplier = 0.5
    },
  },
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
  {
    "ellisonleao/glow.nvim",
    cmd = "Glow",
    ft = { "markdown" },
    keys = {
      { "<leader>mg", "<cmd>Glow<CR>", desc = "Glow で Markdown を float プレビュー" },
    },
    config = function()
      require("glow").setup({
        border = "rounded",
        -- 組み込み style は gruvbox-light の端末色と相性が悪いため、
        -- 本文とコードブロックを明るい背景向けに調整した style を使う。
        style = vim.fn.stdpath("config") .. "/glow-gruvbox-light.json",
        width_ratio = 0.85,
        height_ratio = 0.85,
      })
      -- glow.nvim は vim.loop.spawn(パイプ=非TTY)で glow を起動する glow 1.5.1 時代の
      -- 設計のままで、glow 2.x は非TTY 出力だと色を全て落とすため素のままでは無色になる。
      -- setup が定義した Glow コマンドを同一シグネチャで上書きし、実行中のみ NO_COLOR を
      -- 解除してカラー出力を強制する。
      vim.api.nvim_create_user_command("Glow", function(opts)
        local prev_no_color = vim.env.NO_COLOR
        local prev_force, prev_colorterm = vim.env.CLICOLOR_FORCE, vim.env.COLORTERM
        local prev_terminal_colors = {
          [0] = vim.g.terminal_color_0,
          [8] = vim.g.terminal_color_8,
          [11] = vim.g.terminal_color_11,
        }
        vim.env.NO_COLOR = nil
        vim.env.CLICOLOR_FORCE = "1"
        vim.env.COLORTERM = "truecolor"
        -- Glow's non-TTY output reduces colors to ANSI. Gruvbox Light maps ANSI black
        -- to its light background, so give this preview terminal an explicit palette.
        vim.g.terminal_color_0 = "#282828"
        vim.g.terminal_color_8 = "#665c54"
        vim.g.terminal_color_11 = "#d5c4a1"
        local ok, err = pcall(require("glow").execute, opts)
        vim.env.NO_COLOR = prev_no_color
        vim.env.CLICOLOR_FORCE = prev_force
        vim.env.COLORTERM = prev_colorterm
        vim.g.terminal_color_0 = prev_terminal_colors[0]
        vim.g.terminal_color_8 = prev_terminal_colors[8]
        vim.g.terminal_color_11 = prev_terminal_colors[11]
        if not ok then
          error(err)
        end
      end, { complete = "file", nargs = "?", bang = true })
    end,
  },
}
