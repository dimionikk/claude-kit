# claude-kit

Виїзний набір: одна команда на чужій машині ставить Claude Code, підтягує
правила з цього репо й запускає Claude, готовий до чистки / діагностики.

## Що всередині

| Файл | Призначення |
|---|---|
| `bootstrap.sh` / `bootstrap.ps1` | встановити Claude Code, завантажити кіт, запустити |
| `cleanup.sh` / `cleanup.ps1` | прибрати все з машини після виїзду |
| `CLAUDE.md` | правила поведінки — Claude читає їх при старті (поки порожній) |
| `files/` | файли, які треба мати під рукою на місці |

## Запуск на цільовій машині

**Linux / macOS / git-bash:**
```bash
curl -fsSL -o /tmp/b.sh https://raw.githubusercontent.com/dimionikk/claude-kit/v1/bootstrap.sh && bash /tmp/b.sh
```

**Windows PowerShell:**
```powershell
irm https://raw.githubusercontent.com/dimionikk/claude-kit/v1/bootstrap.ps1 | iex
```

Скрипт спитає `ANTHROPIC_API_KEY` — встав ключ виїзду (Scope: воркспейс
`налаштування комп'ютерів`, ліміт $10). Ключ ніде не зберігається, живе
тільки поки відкрите вікно термінала.

## Змінні (необов'язково)

| Змінна | Дефолт | Що робить |
|---|---|---|
| `CLAUDE_KIT_REF` | `v1` | яку гілку / тег кіта тягнути (`main` для тестів) |
| `CLAUDE_MODEL` | `claude-sonnet-5` | модель |
| `CLAUDE_FIELDWORK_DIR` | `~/claude-fieldwork` | куди клонувати кіт |

## Оновити правила

Правиш `CLAUDE.md` / `files/` у себе -> коміт -> пересуваєш тег:
```bash
git tag -f v1 && git push -f origin v1
```
Наступний `bootstrap` на будь-якій машині підхопить свіже (він щоразу
викачує кіт наново).

## Прибирання після виїзду

```bash
curl -fsSL https://raw.githubusercontent.com/dimionikk/claude-kit/v1/cleanup.sh | bash
```
```powershell
irm https://raw.githubusercontent.com/dimionikk/claude-kit/v1/cleanup.ps1 | iex
```
Потім вручну: **Console -> API keys -> Revoke** ключа цього виїзду.

## Застереження

- Репо публічне — секретів усередині немає й бути не повинно.
- Скрипт **встановлює софт на чужу машину** — питай дозволу власника.
- Claude стартує в стандартному режимі: питає підтвердження перед кожною
  командою й зміною файлу. Не знімай цього.
- Перед будь-яким видаленням — точка відновлення або бекап.
