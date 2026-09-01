$ErrorActionPreference = "SilentlyContinue"
$WorkDir = if ($env:CLAUDE_FIELDWORK_DIR) { $env:CLAUDE_FIELDWORK_DIR } else { "$env:USERPROFILE\claude-fieldwork" }

Write-Host ">> зношу Claude Code" -ForegroundColor Cyan
claude uninstall
npm rm -g @anthropic-ai/claude-code
Remove-Item -Recurse -Force "$env:USERPROFILE\.local\share\claude", "$env:USERPROFILE\.local\bin\claude*"

Write-Host ">> видаляю робочий каталог + увесь стан Claude ($WorkDir)" -ForegroundColor Cyan
Remove-Item -Recurse -Force $WorkDir

# на випадок запуску без CLAUDE_CONFIG_DIR. Якщо в клієнта БУВ свій Claude Code — Ctrl+C
if ((Test-Path "$env:USERPROFILE\.claude") -or (Test-Path "$env:USERPROFILE\.claude.json")) {
  Write-Host "   знайдено %USERPROFILE%\.claude — видаляю через 5с (Ctrl+C, якщо це не твоє)" -ForegroundColor Yellow
  Start-Sleep 5
  Remove-Item -Recurse -Force "$env:USERPROFILE\.claude", "$env:USERPROFILE\.claude.json"
}

Write-Host ">> тимчасові файли" -ForegroundColor Cyan
Remove-Item -Force "$env:TEMP\claude-kit*", "$env:TEMP\b.ps1"

Write-Host ">> історія PowerShell (рядки цього сеансу)" -ForegroundColor Cyan
$h = (Get-PSReadlineOption).HistorySavePath
if ($h -and (Test-Path $h)) {
  (Get-Content $h) -notmatch 'claude-kit|ANTHROPIC_API_KEY|claude-fieldwork|bootstrap\.ps1|raw\.githubusercontent\.com/dimionikk' | Set-Content $h
}
Clear-History

Remove-Item Env:\ANTHROPIC_API_KEY, Env:\CLAUDE_CONFIG_DIR

Write-Host ">> лишки з назвою 'claude' у профілі:" -ForegroundColor Cyan
Get-ChildItem -Path $env:USERPROFILE -Recurse -Depth 2 -Filter "*claude*" -ErrorAction SilentlyContinue |
  Select-Object -ExpandProperty FullName

Write-Host ""
Write-Host "вручну доробити:" -ForegroundColor Yellow
Write-Host "  - Anthropic Console -> API keys -> Revoke ключа цього виїзду"
Write-Host "  - якщо відкривав браузер на цій машині — очисти історію й куки"
Write-Host "    (наступного разу приватне вікно, не логінься в акаунт)"
Write-Host "  - Node.js, якщо ставився заради npm-фолбеку, лишився — прибери за потреби"
Write-Host "  - закрий це вікно PowerShell"
