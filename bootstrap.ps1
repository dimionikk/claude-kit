$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/dimionikk/claude-kit.git"
$Ref     = if ($env:CLAUDE_KIT_REF)       { $env:CLAUDE_KIT_REF }       else { "main" }
$WorkDir = if ($env:CLAUDE_FIELDWORK_DIR) { $env:CLAUDE_FIELDWORK_DIR } else { "$env:USERPROFILE\claude-fieldwork" }
$Model   = if ($env:CLAUDE_MODEL)         { $env:CLAUDE_MODEL }         else { "claude-sonnet-5" }

# увесь стан Claude усередині WorkDir -> cleanup зносить його разом із клоном,
# профіль клієнта (%USERPROFILE%\.claude) не чіпається
$env:CLAUDE_CONFIG_DIR = "$WorkDir\state"

function Say($m)  { Write-Host ">> $m" -ForegroundColor Cyan }
function Fail($m) { Write-Host "!! $m" -ForegroundColor Red; exit 1 }

$env:Path = "$env:USERPROFILE\.local\bin;$env:Path"

# 1. Claude Code
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Say "ставлю Claude Code"
  try {
    Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
    $env:Path = "$env:USERPROFILE\.local\bin;$env:Path"
  } catch {
    Say "нативний інсталятор впав, пробую npm"
    npm install -g @anthropic-ai/claude-code
  }
}
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) { Fail "claude не встановився" }
Say ("claude: " + (Get-Command claude).Source)

# 2. кіт — завжди свіжа копія
if (Test-Path $WorkDir) { Remove-Item -Recurse -Force $WorkDir }
if (Get-Command git -ErrorAction SilentlyContinue) {
  Say "клоную кіт ($Ref) -> $WorkDir"
  git clone --depth 1 --branch $Ref $RepoUrl $WorkDir
} else {
  Say "нема git — качаю архів"
  $zip = "$env:TEMP\claude-kit.zip"
  $ex  = "$env:TEMP\claude-kit-extract"
  try   { Invoke-WebRequest "https://github.com/dimionikk/claude-kit/archive/refs/tags/$Ref.zip" -OutFile $zip }
  catch { Invoke-WebRequest "https://github.com/dimionikk/claude-kit/archive/refs/heads/$Ref.zip" -OutFile $zip }
  Remove-Item -Recurse -Force $ex -ErrorAction SilentlyContinue
  Expand-Archive $zip -DestinationPath $ex -Force
  Move-Item (Get-ChildItem $ex -Directory | Select-Object -First 1).FullName $WorkDir
  Remove-Item $zip, $ex -Recurse -Force -ErrorAction SilentlyContinue
}

# 3. ключ — тільки в пам'яті сесії
# видимий Read-Host: вставка в прихований (-AsSecureString) не працює в консолі Windows/SPICE
if (-not $env:ANTHROPIC_API_KEY) {
  $env:ANTHROPIC_API_KEY = (Read-Host "ANTHROPIC_API_KEY (встав ключ, Enter)").Trim()
}
if ($env:ANTHROPIC_API_KEY.Length -lt 40) {
  Fail "ключ порожній або обрізаний (довжина $($env:ANTHROPIC_API_KEY.Length)) — вставка не спрацювала, спробуй ще раз"
}

# 4. запуск
New-Item -ItemType Directory -Force -Path $env:CLAUDE_CONFIG_DIR | Out-Null
Set-Location $WorkDir
Say "запускаю claude ($Model) у $WorkDir"
Say "стан Claude: $env:CLAUDE_CONFIG_DIR (видалиться разом із $WorkDir через cleanup)"
claude --model $Model
