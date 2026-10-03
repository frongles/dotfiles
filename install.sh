#!/usr/bin/env bash
# Create the symlinks from $HOME and ~/.config into this dotfiles repo.
# Works on macOS and Linux. Safe to re-run:
#   - a link that already points at the right place is left alone
#   - an existing real file/dir (or a link pointing elsewhere) is moved aside
#     to <name>.bak.<timestamp> instead of being overwritten
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

# source (relative to the repo) -> destination
LINKS=(
  # Home directory
  ".gitconfig:$HOME/.gitconfig"
  ".gitignore:$HOME/.gitignore"
  ".gitmessage:$HOME/.gitmessage"
  ".tmux.conf:$HOME/.tmux.conf"
  ".zshrc:$HOME/.zshrc"

  # ~/.config
  "fish:$CONFIG/fish"
  "mise:$CONFIG/mise"
  "nvim:$CONFIG/nvim"
  "pgcli/config:$CONFIG/pgcli/config"
  "starship.toml:$CONFIG/starship.toml"
)

link() {
  local src="$DOTFILES/$1" dest="$2"

  if [[ ! -e "$src" ]]; then
    echo "skip    $dest (missing in repo: $1)"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    echo "ok      $dest"
    return
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    mv "$dest" "$dest.bak.$STAMP"
    echo "backup  $dest -> $dest.bak.$STAMP"
  fi

  ln -s "$src" "$dest"
  echo "link    $dest -> $src"
}

for entry in "${LINKS[@]}"; do
  link "${entry%%:*}" "${entry#*:}"
done
