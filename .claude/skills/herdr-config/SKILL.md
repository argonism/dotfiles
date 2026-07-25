---
name: herdr-config
description: herdr（AI エージェント統合ターミナルマルチプレクサ）の設定を変更・調整する。config.toml の編集、キーバインド・テーマ・サイドバー・通知・サウンド・worktree などの設定変更、herdr の挙動調整の依頼で使用する。
---

# herdr の設定をいじる

## herdr のメンタルモデル

herdr は AI エージェント統合を備えたターミナルマルチプレクサ（tmux 系）。

- **階層構造**: Workspace → Tab → Pane。Workspace はプロジェクト単位のトップレベルコンテナ、Tab はその中のレイアウト（logs / server / review など）、Pane が実際のターミナルプロセス。
- **Agent**: Pane 内で動く AI アシスタント（Claude, Codex, Pi, Droid など）。herdr が foreground 検出や manifest で認識し、状態を追跡する: `Blocked`（入力/承認待ち）/ `Working` / `Done`（完了・未レビュー）/ `Idle` / `Unknown`。サイドバーはこの状態を集約して「どのプロジェクトが注意を要するか」を表示する。
- **client-server**: 常駐 server が pane とプロセス状態を所有し、client はそれに attach する TUI。detach（`ctrl+b q`）しても server は生き続ける。
- **Session**: server の名前空間。named session を作ると pane / socket が分離された独立環境になる。
- **モード**: terminal mode（キーは focus 中の pane へ）/ prefix mode（`ctrl+b` の後に action キー）/ navigate mode（プレーンキーでの workspace/pane ナビゲーション）。
- **Worktree**: git worktree の checkout をサイドバーから管理。
- **設計思想**: 「config なしで動く」。設定はすべて任意で、shell/editor の入力を奪わない prefix-first キーバインドが基本。不正な値は起動時 warning とともに安全な default に fallback する。

## この dotfiles での設定ファイルの場所（重要）

`~/.config/herdr` は **ディレクトリごと** このリポジトリの `config/.config/herdr/` への symlink（`recipes/darwin/default.rb` の `dotfile '.config/herdr'`）。

- 編集対象: `config/.config/herdr/config.toml`（= `~/.config/herdr/config.toml` と同一実体。編集は即座に live 設定に反映される）
- 同じディレクトリに runtime ファイル（`herdr.log`, `herdr-server.log`, `herdr-client.log`, `*.sock`, `session.json`）が生成される。**config.toml 以外はコミットしないこと**。

## 設定変更の手順

1. `config/.config/herdr/config.toml` を読み、該当セクションを編集する（TOML 形式）。
2. 反映: `herdr server reload-config` を実行する（大半の UI 設定は再起動不要で適用される）。アプリ内ではグローバルメニューの「reload config」でも同じ。
3. デフォルト値の確認: `herdr --default-config`（全デフォルト設定を出力する）。既存 config にないキーを追加する際はこれで正確なキー名とデフォルトを確認する。
4. キーバインドを初期状態に戻すとき: `herdr config reset-keys`（config.toml をバックアップした上で v2 デフォルトにリセット）。

## 主要設定リファレンス

現在の config.toml のセクション: `[theme]` `[terminal]` `[update]` `[keys]` `[ui]` `[ui.toast]` `[ui.sound]` `[session]` `[remote]` `[experimental]` `[advanced]`

### terminal

```toml
[terminal]
default_shell = "nu"     # 実行ファイル名 or パス。未指定は $SHELL → /bin/sh
shell_mode = "auto"      # "auto" | "login" | "non_login"。auto は macOS で login shell
new_cwd = "follow"       # "follow"(元 pane を継承) | "home" | "current" | 固定パス
```

### keys（キーバインド）

```toml
[keys]
prefix = "ctrl+b"
new_tab = "prefix+c"
next_tab = ["prefix+n", "ctrl+alt+]"]   # 配列で複数割当可
split_horizontal = "prefix+minus"
switch_tab = "prefix+1..9"              # indexed jump
```

キー構文ルール:
- `prefix+n` = prefix を押してから `n`。`ctrl+alt+n` = 直接ショートカット。
- 特殊キー: `enter` `tab` `esc` `left` `right` `up` `down`。記号は名前で: `minus` `comma` `ampersand` `plus` `backtick`。
- **安全ルール**: 修飾なしの印字可能キー（`n` 等）はアプリ入力を奪うため原則使わない。`prefix+` を付ける。
- navigate mode 用キー（`navigate_*`）は逆に `prefix+` 不可。`esc` `enter` `tab` `shift+tab` `left` `right`、無修飾の `1`-`9` も不可。

### keys.command（カスタムコマンドのキーバインド）

```toml
[[keys.command]]
key = "prefix+alt+g"
type = "popup"            # "popup"(モーダル) | "pane"(一時 zoom、終了で閉じる) | "shell"(バックグラウンド) | "plugin_action"
command = "lazygit"
description = "run lazygit"
width = "80%"             # セル数 or パーセント。省略で半分サイズ
height = "80%"
```

コマンドから使える環境変数: `HERDR_SOCKET_PATH` `HERDR_BIN_PATH` `HERDR_ACTIVE_WORKSPACE_ID` `HERDR_ACTIVE_TAB_ID` `HERDR_ACTIVE_PANE_ID` `HERDR_ACTIVE_PANE_CWD`

### theme

```toml
[theme]
name = "catppuccin"
auto_switch = true              # ターミナルの light/dark に追従
light_name = "catppuccin-latte"
dark_name = "catppuccin"

[theme.custom]                  # 色トークンの個別上書き
panel_bg = "reset"              # hex / 色名 / rgb(r,g,b) / reset 系 (reset, default, none, transparent)
accent = "#a6e3a1"
```

上書き可能トークン: `accent` `panel_bg` `surface0-1` `overlay0-1` `text` `subtext0` `mauve` `green` `yellow` `red` `blue` `teal` `peach` など。

### ui.sidebar（サイドバー行レイアウト）

```toml
[ui.sidebar.agents]
row_gap = 0                     # エントリ間の空行数
rows = [
  ["state_icon", "workspace", "tab"],
  ["agent"],
]

[ui.sidebar.agents.rows_by_agent]   # agent 別上書き。キーは canonical ID（claude, codex, pi）で case-sensitive
claude = [
  ["state_icon", "agent", "state_text"],
  ["terminal_title_stripped"],
]

[ui.sidebar.spaces]
rows = [
  ["state_icon", "workspace"],
  ["branch", "git_status"],
]
```

- agents 行トークン: `state_icon` `state_text` `workspace` `tab` `pane` `agent` `terminal_title` `terminal_title_stripped` `$name`（カスタム metadata）
- spaces 行トークン: `state_icon` `state_text` `workspace` `branch` `git_status` `$name`
- 制約: 最大 16 行 × 16 トークン。値がない要素とその区切りは非表示になる。

### ui.toast / ui.sound（通知・サウンド）

```toml
[ui.toast]
delivery = "herdr"       # "herdr" | "terminal" | "system" | "off"
delay_seconds = 1        # 0-3600

[ui.toast.herdr]
position = "bottom-right"

[ui.sound]
path = "sounds/notification.mp3"   # MP3 のみ。相対パスは config ディレクトリ基準
done_path = "sounds/done.mp3"
request_path = "sounds/request.mp3"

[ui.sound.agents]        # agent 別: "default" | "on" | "off"（droid はデフォルト off）
claude = "on"
```

### その他のセクション

```toml
[worktrees]
directory = "~/.herdr/worktrees"   # <directory>/<repo>/<branch-slug> に checkout

[remote]
manage_ssh_config = true           # keepalive・接続再利用付きの一時 SSH config を生成。false で素の ssh

[session]
resume_agents_on_restore = true    # restore 時に agent をネイティブセッションへ復帰

[update]
channel = "stable"                 # "stable" | "preview"

[advanced]
scrollback_limit_bytes = 10485760  # pane あたりのバッファ上限（default 10MB）

[experimental]
kitty_graphics = true                          # default off
reveal_hidden_cursor_for_cjk_ime = true        # macOS: 日本語 IME のカーソル位置追跡
cjk_ime_agents = ["claude", "pi", "codex"]
switch_ascii_input_source_in_prefix = true     # macOS: prefix mode で英数入力に切替
allow_nested = false                           # herdr 内 herdr
pane_history = false                           # 画面履歴の永続化
```

## 環境変数

| 変数 | 用途 |
|------|------|
| `HERDR_CONFIG_PATH` | config ファイルパスの上書き |
| `HERDR_SESSION` | CLI コマンドが対象とする named session の選択 |
| `HERDR_SOCKET_PATH` | socket パスの上書き |
| `HERDR_LOG` | ログフィルタ（例: `HERDR_LOG=herdr=debug`） |
| `HERDR_DISABLE_SOUND` | config で有効でもサウンドを無効化 |

## トラブルシューティング

- ログ: `~/.config/herdr/herdr.log` / `herdr-client.log` / `herdr-server.log`（このリポジトリでは `config/.config/herdr/` 内に実体がある）。自動ローテーションされる。
- 設定が反映されない → `herdr server reload-config` を実行したか確認。それでもだめなら server 再起動が必要な設定の可能性。
- 不正な値は起動時に warning を出して default に fallback する（エラーで落ちない）。

## ドキュメントリンク

| ページ | URL |
|--------|-----|
| Configuration（本 skill の主典拠） | https://herdr.dev/docs/configuration/ |
| Config reference（全 146 キーの網羅リファレンス） | https://herdr.dev/docs/config-reference/ |
| Concepts | https://herdr.dev/docs/concepts/ |
| Keyboard | https://herdr.dev/docs/keyboard/ |
| Agents | https://herdr.dev/docs/agents/ |
| Session state and restore | https://herdr.dev/docs/session-state/ |
| Persistence and remote access | https://herdr.dev/docs/persistence-remote/ |
| Plugins | https://herdr.dev/docs/plugins/ |
| CLI reference | https://herdr.dev/docs/cli-reference/ |
| Socket API | https://herdr.dev/docs/socket-api/ |
| Troubleshooting | https://herdr.dev/docs/troubleshooting/ |

ここに載っていないキーや詳細が必要な場合は Config reference / CLI reference を WebFetch で参照すること。

## 関連: 公式 agent skill（本 skill とは別物）

herdr 公式にも SKILL.md があるが、それは「herdr の pane 内で動く agent が socket 経由で herdr を**操作**する」（pane 分割、出力読取、隣接 agent との協調など）ためのもの。設定編集用の本 skill とは役割が異なる。

- 公式: https://github.com/ogulcancelik/herdr/blob/master/SKILL.md
- 導入: `npx skills add ogulcancelik/herdr --skill herdr -g`
- 公式 skill は `HERDR_ENV=1` が設定された herdr 管理下の pane でのみ動作する安全機構を持つ。
