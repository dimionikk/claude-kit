#!/usr/bin/env bash
set -uo pipefail

WORKDIR="${CLAUDE_FIELDWORK_DIR:-$HOME/claude-fieldwork}"

echo ">> зношу Claude Code"
claude uninstall 2>/dev/null || true
npm rm -g @anthropic-ai/claude-code 2>/dev/null || true
rm -rf "$HOME/.local/share/claude" "$HOME/.local/bin/claude"

echo ">> видаляю робочі каталоги"
rm -rf "$WORKDIR" "$HOME/.claude" "$HOME/.claude.json"

unset ANTHROPIC_API_KEY 2>/dev/null || true

cat <<'EOF'

готово. лишилось вручну:
  - Anthropic Console -> API keys -> Revoke ключа цього виїзду
  - перевір ~/.bashrc ~/.zshrc ~/.profile — чи не лишився export ANTHROPIC_API_KEY
  - закрий це вікно термінала
EOF
