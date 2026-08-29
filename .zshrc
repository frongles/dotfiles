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

# go binaries
export PATH="$PATH:$HOME/go/bin"

export PATH="$PATH:$HOME/.local/bin"

# aliases
alias ls="eza -la"


export NVM_DIR="$HOME/.nvm"
export NVM_SYMLINK_CURRENT=true

## Lazy load nvm
nvm() {
  unset -f nvm node npm npx  # remove the placeholder functions
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm "$@"  # run the actual command you called
}


# Same for node/npm/npx so they also trigger the load
node() { nvm; node "$@"; }
npm()  { nvm; npm "$@"; }
npx()  { nvm; npx "$@"; }


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


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
