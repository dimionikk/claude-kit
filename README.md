# claude-kit

Команди для копіювання (відкрий цю сторінку в браузері на цільовій машині).

## Запуск

**Windows PowerShell:**
```
irm https://raw.githubusercontent.com/dimionikk/claude-kit/v1/bootstrap.ps1 | iex
```

**Linux / macOS / git-bash:**
```
curl -fsSL -o /tmp/b.sh https://raw.githubusercontent.com/dimionikk/claude-kit/v1/bootstrap.sh && bash /tmp/b.sh
```

Якщо PowerShell лається на execution policy:
```
Set-ExecutionPolicy -Scope Process Bypass -Force
```

## Прибирання після виїзду

**Windows PowerShell:**
```
irm https://raw.githubusercontent.com/dimionikk/claude-kit/v1/cleanup.ps1 | iex
```

**Linux / macOS / git-bash:**
```
curl -fsSL https://raw.githubusercontent.com/dimionikk/claude-kit/v1/cleanup.sh | bash
```

Потім вручну: Anthropic Console -> API keys -> Revoke ключа цього виїзду.

## Тест проти гілки main (замість тега v1)

Постав змінну перед командою запуску:
```
$env:CLAUDE_KIT_REF = "main"
```
```
export CLAUDE_KIT_REF=main
```
і в командах вище заміни `/v1/` на `/main/`.
