$ErrorActionPreference = "SilentlyContinue"
$WorkDir = if ($env:CLAUDE_FIELDWORK_DIR) { $env:CLAUDE_FIELDWORK_DIR } else { "$env:USERPROFILE\claude-fieldwork" }

Write-Host ">> зношу Claude Code" -ForegroundColor Cyan
claude uninstall
npm rm -g @anthropic-ai/claude-code
Remove-Item -Recurse -Force "$env:USERPROFILE\.local\share\claude", "$env:USERPROFILE\.local\bin\claude*"

Write-Host ">> видаляю робочі каталоги" -ForegroundColor Cyan
Remove-Item -Recurse -Force $WorkDir, "$env:USERPROFILE\.claude", "$env:USERPROFILE\.claude.json"

Remove-Item Env:\ANTHROPIC_API_KEY

Write-Host ""
Write-Host "готово. лишилось вручну:" -ForegroundColor Yellow
Write-Host "  - Anthropic Console -> API keys -> Revoke ключа цього виїзду"
Write-Host "  - закрий це вікно PowerShell (щоб не лишилось змінної в пам'яті)"
