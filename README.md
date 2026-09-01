# claude-kit

Команди для копіювання (відкрий цю сторінку в браузері на цільовій машині).

## Запуск

**Windows PowerShell:**
```
irm https://raw.githubusercontent.com/dimionikk/claude-kit/main/bootstrap.ps1 | iex
```

**Linux / macOS / git-bash:**
```
curl -fsSL -o /tmp/b.sh https://raw.githubusercontent.com/dimionikk/claude-kit/main/bootstrap.sh && bash /tmp/b.sh
```

Якщо PowerShell лається на execution policy:
```
Set-ExecutionPolicy -Scope Process Bypass -Force
```

Скрипт спитає `ANTHROPIC_API_KEY` — встав ключ виїзду (Scope: воркспейс
`налаштування комп'ютерів`, ліміт $10). Ключ живе тільки в цьому вікні.

## Прибирання після виїзду

Закриття вікна **нічого не чистить** — зникає лише ключ із пам'яті.
Стан Claude лишається на диску, доки не запустиш cleanup.

**Windows PowerShell:**
```
irm https://raw.githubusercontent.com/dimionikk/claude-kit/main/cleanup.ps1 | iex
```

**Linux / macOS / git-bash:**
```
curl -fsSL https://raw.githubusercontent.com/dimionikk/claude-kit/main/cleanup.sh | bash
```

## Який слід лишається на машині

- Робочий каталог `~/claude-fieldwork/` — клон кіта.
- `~/claude-fieldwork/state/` — увесь стан Claude (транскрипти, сесії, конфіг),
  винесений сюди через `CLAUDE_CONFIG_DIR`, щоб не чіпати `~/.claude` клієнта.
- Встановлений Claude Code: `~/.local/share/claude`, `~/.local/bin/claude`.
- Рядки в історії шелла / PowerShell (ключ у них не потрапляє — вводиться
  через prompt, не як команда).
- Якщо ставився Node.js заради npm-фолбеку — лишається.

`cleanup` знімає перші чотири пункти + чистить згадки з історії. Node і дані
браузера — вручну (тому браузер на чужій машині відкривай приватним вікном
і не логінься в акаунт Anthropic — створюй ключ деінде).

## Пін на конкретну версію

За замовчуванням усе тягнеться з `main`. Щоб зафіксувати версію — постав тег
і використовуй його замість `main` у посиланнях і в `CLAUDE_KIT_REF`.
