# Starship shell prompts
eval "$(starship init zsh)"

# cache for rust builds
export RUSTC_WRAPPER=/opt/homebrew/bin/sccache

# sccache max size
export SCCACHE_CACHE_SIZE="20G"

# go binaries
export PATH="$PATH:$HOME/go/bin"

export PATH="$PATH:$HOME/.local/bin"

# aliases
alias ls="eza -la"

## Lazy load nvm
nvm() {
  unset -f nvm node npm npx  # remove the placeholder functions
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm "$@"  # run the actual command you called
}


# Same for node/npm/npx so they also trigger the load
node() { nvm; node "$@"; }
npm()  { nvm; npm "$@"; }
npx()  { nvm; npx "$@"; }
