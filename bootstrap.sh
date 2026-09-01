#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/dimionikk/claude-kit.git"
ARCHIVE_BASE="https://github.com/dimionikk/claude-kit/archive/refs"
REF="${CLAUDE_KIT_REF:-v1}"
WORKDIR="${CLAUDE_FIELDWORK_DIR:-$HOME/claude-fieldwork}"
MODEL="${CLAUDE_MODEL:-claude-sonnet-5}"

say() { printf '\033[1;36m>> %s\033[0m\n' "$*"; }
err() { printf '\033[1;31m!! %s\033[0m\n' "$*" >&2; }

export PATH="$HOME/.local/bin:$PATH"

# 1. Claude Code
if ! command -v claude >/dev/null 2>&1; then
  say "ставлю Claude Code"
  if curl -fsSL https://claude.ai/install.sh | bash; then
    export PATH="$HOME/.local/bin:$PATH"
  else
    err "нативний інсталятор впав, пробую npm"
    npm install -g @anthropic-ai/claude-code
  fi
fi
command -v claude >/dev/null 2>&1 || { err "claude не встановився"; exit 1; }
say "claude: $(command -v claude)"

# 2. кіт — завжди свіжа копія
say "завантажую кіт ($REF) -> $WORKDIR"
rm -rf "$WORKDIR"
if command -v git >/dev/null 2>&1; then
  git clone --depth 1 --branch "$REF" "$REPO_URL" "$WORKDIR"
else
  say "нема git — качаю архів"
  mkdir -p "$WORKDIR"
  if ! curl -fsSL "$ARCHIVE_BASE/tags/$REF.tar.gz" | tar -xz -C "$WORKDIR" --strip-components=1; then
    curl -fsSL "$ARCHIVE_BASE/heads/$REF.tar.gz" | tar -xz -C "$WORKDIR" --strip-components=1
  fi
fi

# 3. ключ — тільки в пам'яті сесії
if [ -z "${ANTHROPIC_API_KEY:-}" ]; then
  printf 'ANTHROPIC_API_KEY: '
  read -rs ANTHROPIC_API_KEY </dev/tty
  printf '\n'
fi
ANTHROPIC_API_KEY="$(printf '%s' "${ANTHROPIC_API_KEY:-}" | tr -d '[:space:]')"
export ANTHROPIC_API_KEY
if [ "${#ANTHROPIC_API_KEY}" -lt 40 ]; then
  err "ключ порожній або обрізаний (${#ANTHROPIC_API_KEY} символів) — спробуй ще раз"
  exit 1
fi

# 4. запуск
cd "$WORKDIR"
say "запускаю claude ($MODEL) у $(pwd)"
exec claude --model "$MODEL"
