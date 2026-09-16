# Starship shell prompts
eval "$(starship init zsh)"

eval "$(direnv hook zsh)"

# cache for rust builds
export RUSTC_WRAPPER=/opt/homebrew/bin/sccache

# sccache max size
export SCCACHE_CACHE_SIZE="20G"

export CARGO_PROFILE_DEV_DEBUG=false
export CARGO_PROFILE_DEV_STRIP=true

export PSQL_PAGER="bat --wrap never --plain"
export PAGER="bat --wrap=never --plain"

# go binaries
export PATH="$PATH:$HOME/go/bin"

export PATH="$PATH:$HOME/.local/bin"

# aliases
alias ls="eza -la"

alias gs="git status"
alias gl="git lg"
alias gd="git diff"

alias gw="./gradlew"


# Cargo cross automation
crossmac() {
  TMPDIR="$HOME/.cache/rust-cross-compiler" cargo cross build \
    --target aarch64-unknown-linux-gnu --glibc-version 2.34 "$@"
}
crosslinux() {
  TMPDIR="$HOME/.cache/rust-cross-compiler" cargo cross build \
    --target x86_64-unknown-linux-gnu --glibc-version 2.34 "$@"
}

bindkey -v

export KEYTIMEOUT=1

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[2 q'  # block cursor, normal mode
  else
    echo -ne '\e[6 q'  # bar cursor, insert mode
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  #zle -K vicmd;
  echo -ne '\e[6 q'  # start each new prompt in insert-mode cursor
}
zle -N zle-line-init

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --exclude .git --exclude node_modules --exclude Library --exclude go --exclude venv/'

export ANDROID_HOME="$HOME/Library/Android/sdk"

export PATH="$ANDROID_HOME/platform-tools:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

nvimchanges() {
    git diff --name-only --relative --diff-filter=ACMR -z | xargs -0 nvim --
}

autoload -U compinit
compinit

source "$(brew --prefix)/share/zsh/site-functions/_gradle"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/frasercrumpler/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/frasercrumpler/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/frasercrumpler/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/frasercrumpler/google-cloud-sdk/completion.zsh.inc'; fi
