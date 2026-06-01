#!/usr/bin/env bash

# Environment bootstrap for Cursor's non-interactive agent shell.
# Keep this bash-compatible and avoid interactive prompt/completion setup.

if [ -n "${CURSOR_AGENT_ENV_LOADED:-}" ]; then
  return 0 2>/dev/null || exit 0
fi
export CURSOR_AGENT_ENV_LOADED=1

prepend_path() {
  for entry in "$@"; do
    [ -n "$entry" ] || continue
    case ":${PATH:-}:" in
      *":$entry:"*) ;;
      *) export PATH="$entry:${PATH:-}" ;;
    esac
  done
}

append_path() {
  for entry in "$@"; do
    [ -n "$entry" ] || continue
    case ":${PATH:-}:" in
      *":$entry:"*) ;;
      *) export PATH="${PATH:-}:$entry" ;;
    esac
  done
}

export DOTFILES_PATH="$HOME/dotfiles"
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

prepend_path \
  "$HOME/.local/bin" \
  "$HOME/.npm-global/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.local/share/gem/ruby/3.0.0/bin" \
  "$DOTFILES_PATH/allwaysinpath"

export DOTNET_ROOT="$HOME/.dotnet"
prepend_path "$DOTNET_ROOT" "$DOTNET_ROOT/tools"
append_path "$HOME/Programs/netcoredbg"

prepend_path "/opt/cuda/bin"
export LD_LIBRARY_PATH="/opt/cuda/lib64${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"

export PASSWORD_STORE_DIR="/home/hector/Drive/Ica/password-store"
export EDITOR="nvim"
export VISUAL="nvim"

export HSA_OVERRIDE_GFX_VERSION=10.3.0
export AMD_SERIALIZE_KERNEL=3
export ROC_ENABLE_PREEMPTION=0
export HSA_ENABLE_SDMA=0

export BUN_INSTALL="$HOME/.bun"
prepend_path "$BUN_INSTALL/bin"

if [ -f "$HOME/.zshrc.local" ]; then
  # Contains local secrets/credentials and additional PATH setup.
  # It is currently POSIX-compatible enough to source from bash.
  . "$HOME/.zshrc.local"
fi

if [ -d "${XDG_RUNTIME_DIR:-}" ] && command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --shell bash --use-on-cd)" || true
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv export bash)" || true
fi

export CHROME_EXECUTABLE="/usr/sbin/chromium"
