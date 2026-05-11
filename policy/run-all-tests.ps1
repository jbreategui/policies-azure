# Equivalente PowerShell de run-all-tests.sh.
# Uso (desde donde sea):
#   pwsh policy/run-all-tests.ps1
# o:
#   .\policy\run-all-tests.ps1

$ErrorActionPreference = 'Continue'

$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$PolicyDir   = $ScriptDir
$FixturesDir = Join-Path $ScriptDir 'fixtures'
$RealPlan    = Join-Path $ScriptDir '..\environments\dev\tfplan.json'

function Write-Section($title) {
  Write-Output ''
  Write-Output ('=' * 60)
  Write-Output " $title"
  Write-Output ('=' * 60)
}

if (-not (Get-Command conftest -ErrorAction SilentlyContinue)) {
  Write-Error "'conftest' no está en el PATH. Instalalo desde https://www.conftest.dev/"
  exit 127
}

Write-Section '1) UNIT TESTS — conftest verify'
conftest verify --policy $PolicyDir

Write-Section '2) NEGATIVE FIXTURES — cada uno debe terminar en FAIL'
Get-ChildItem -Path $FixturesDir -Filter 'violates-*.json' | ForEach-Object {
  Write-Output ''
  Write-Output "--- $($_.Name) ---"
  conftest test --policy $PolicyDir $_.FullName
}

if (Test-Path $RealPlan) {
  Write-Section '3) PLAN REAL — debe pasar todo (0 failures)'
  conftest test --policy $PolicyDir $RealPlan
} else {
  Write-Section "3) PLAN REAL — omitido (no existe $RealPlan)"
  Write-Output 'Si querés validarlo, generalo primero desde environments/dev:'
  Write-Output '  terraform plan -out=tfplan; terraform show -json tfplan > tfplan.json'
}

Write-Section 'DONE'
