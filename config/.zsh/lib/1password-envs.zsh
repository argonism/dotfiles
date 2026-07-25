# ~/.zshrc（もしくは source する設定ファイル）に置く
typeset -A OP_ENVS=(
  wm  uy633pb2ehelmnqh3wdlaiqwsq
  fronteo kthc5cwudibgpqyjdido2yzjvu
)

# op run --environment のラッパー: `openv dev printenv`
s() {
  local name=$1; shift
  local id=${OP_ENVS[$name]}
  if [[ -z $id ]]; then
    print -u2 "openv: unknown env '$name' (available: ${(k)OP_ENVS})"
    return 1
  fi
  op run --environment "$id" --no-masking -- "$@"
}

# op environment read のラッパー: `openv-read prod`
openv-read() {
  local id=${OP_ENVS[$1]}
  [[ -z $id ]] && { print -u2 "openv-read: unknown env '$1'"; return 1; }
  op environment read "$id"
}

# タブ補完（名前を Tab で切り替え）
_openv() { local -a n; n=(${(k)OP_ENVS}); _describe 'environment' n }
compdef _openv openv openv-read
