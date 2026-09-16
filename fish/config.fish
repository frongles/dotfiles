if status is-interactive
    # Commands to run in interactive sessions can go here
    mise activate fish | source
    starship init fish | source
    fish_vi_key_bindings

    set -g fish_escape_delay_ms 10

    alias ls "eza -la"
    alias gs="git status"
    alias gl="git lg"
    alias gd="git diff"
    alias gw="./gradlew"
end


# Starship shell prompt

# Rust build cache
set -gx RUSTC_WRAPPER /opt/homebrew/bin/sccache
set -gx SCCACHE_CACHE_SIZE 20G

set -gx CARGO_PROFILE_DEV_DEBUG false
set -gx CARGO_PROFILE_DEV_STRIP true

set -gx EDITOR nvim
set -gx PAGER "bat --wrap never --plain"


# PostgreSQL
set -gx PSQL_PAGER "bat --wrap never --plain"


# Paths
fish_add_path $HOME/go/bin
fish_add_path $HOME/.local/bin


# Cargo cross automation
function crossmac
    env TMPDIR="$HOME/.cache/rust-cross-compiler" cargo cross build \
        --target aarch64-unknown-linux-gnu \
        --glibc-version 2.34 \
        $argv
end

function crosslinux
    env TMPDIR="$HOME/.cache/rust-cross-compiler" cargo cross build \
        --target x86_64-unknown-linux-gnu \
        --glibc-version 2.34 \
        $argv
end

function nvimchanges
    git diff --name-only --relative --diff-filter=ACMR -z | xargs -0 nvim --
end




# fzf
set -gx FZF_DEFAULT_COMMAND \
    "fd --type f --strip-cwd-prefix --exclude .git --exclude node_modules --exclude Library --exclude go --exclude venv/"


# Android
set -gx ANDROID_HOME "$HOME/Library/Android/sdk"

fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin


# PostgreSQL tools
fish_add_path /opt/homebrew/opt/libpq/bin
