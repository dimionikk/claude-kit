#!/usr/bin/env bash
set -uo pipefail

WORKDIR="${CLAUDE_FIELDWORK_DIR:-$HOME/claude-fieldwork}"

echo ">> зношу Claude Code"
claude uninstall 2>/dev/null || true
npm rm -g @anthropic-ai/claude-code 2>/dev/null || true
rm -rf "$HOME/.local/share/claude" "$HOME/.local/bin/claude"

echo ">> видаляю робочий каталог + увесь стан Claude ($WORKDIR)"
rm -rf "$WORKDIR"

# на випадок, якщо запускали без CLAUDE_CONFIG_DIR і щось лягло в дефолт.
# УВАГА: якщо в клієнта БУВ свій Claude Code до тебе — не видаляй це, Ctrl+C
if [ -e "$HOME/.claude" ] || [ -e "$HOME/.claude.json" ]; then
  echo "   знайдено $HOME/.claude — видаляю (5с на Ctrl+C, якщо це не твоє)"
  sleep 5
  rm -rf "$HOME/.claude" "$HOME/.claude.json"
fi

echo ">> тимчасові файли"
rm -f /tmp/b.sh /tmp/claude-kit.tar.gz /tmp/claude-kit.zip

echo ">> історія шелла (рядки цього сеансу)"
for f in "$HOME/.bash_history" "$HOME/.zsh_history"; do
  [ -f "$f" ] && sed -i '/claude-kit\|ANTHROPIC_API_KEY\|claude-fieldwork\|bootstrap\.\(sh\|ps1\)\|raw\.githubusercontent\.com\/dimionikk/d' "$f"
done

unset ANTHROPIC_API_KEY CLAUDE_CONFIG_DIR 2>/dev/null || true

echo ">> лишки з назвою 'claude' у домашній теці:"
find "$HOME" -maxdepth 3 -iname '*claude*' 2>/dev/null || true

cat <<'EOF'

вручну доробити:
  - Anthropic Console -> API keys -> Revoke ключа цього виїзду
  - якщо відкривав браузер на цій машині — очисти історію й куки
    (наступного разу користуйся приватним вікном і не логінься в акаунт)
  - Node.js, якщо ставився заради npm-фолбеку, лишився — прибери за потреби
  - у поточному терміналі: history -c ; потім закрий вікно
EOF
