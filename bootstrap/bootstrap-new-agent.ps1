# ============================================================
#  CPUVETS / BITCLOUD NEW-AGENT BOOTSTRAP  (Windows / PowerShell)
#  Run this first thing so a fresh agent is connected to:
#    (1) Git + the agent-hub repo (via per-device SSH key)
#    (2) The public VPS (89.117.23.163) over SSH
#  Per-device GitHub SSH key: each machine gets its OWN key so
#  no PAT is shared. You must add the printed public key to
#  GitHub before git push/pull will work.
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host "`n=== 1/4 Verifying Git ===`n" -ForegroundColor Cyan
$git = "C:\Program Files\Git\cmd\git.exe"
if (Test-Path $git) {
    Write-Host "git found: $git"
    & $git --version
} else {
    Write-Host "ERROR: git not found at $git. Install Git, then re-run." -ForegroundColor Red
    exit 1
}

Write-Host "`n=== 2/4 GitHub auth (per-device SSH key) ===`n" -ForegroundColor Cyan
$keyFile = "$env:USERPROFILE\.ssh\github_key"
$isWin = $env:OS -like "Windows*"

# 2a. Set git identity (same everywhere)
& $git config --global user.email "jforsyth32@gmail.com"
& $git config --global user.name  "jforsyth32"
& $git config --global core.autocrlf false
& $git config --global init.defaultBranch main

# 2b. Ensure ~/.ssh exists
if (-not (Test-Path "$env:USERPROFILE\.ssh")) {
    New-Item -ItemType Directory -Path "$env:USERPROFILE\.ssh" | Out-Null
    Write-Host "Created ~/.ssh"
}

# 2c. Generate a per-device GitHub SSH key if none exists
if (-not (Test-Path "$keyFile")) {
    Write-Host "No existing GitHub SSH key. Generating a NEW per-device key..." -ForegroundColor Yellow
    ssh-keygen -t ed25519 -C "jforsyth32@gmail.com" -f $keyFile -N '""'
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: ssh-keygen failed. Is OpenSSH client installed?" -ForegroundColor Red
        exit 1
    }
    Write-Host ""
    Write-Host "=== ADD THIS PUBLIC KEY TO GITHUB (once per device) ===" -ForegroundColor Green
    Write-Host "Open  https://github.com/settings/ssh/new  and paste:" -ForegroundColor Cyan
    Write-Host ""
    Get-Content "$keyFile.pub"
    Write-Host ""
    Write-Host "Title it e.g. 'laptop-<name>'. After adding, re-run this script" -ForegroundColor Cyan
    Write-Host "(or 'ssh -T git@github.com' to test) — do NOT reuse another device's key." -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host "GitHub SSH key already present: $keyFile (per-device)."
}

# 2d. Ensure SSH config points GitHub at the key
$sshCfg = "$env:USERPROFILE\.ssh\config"
$cfgText = @"
Host github.com
  HostName github.com
  User git
  IdentityFile $keyFile
  IdentitiesOnly yes
"@
if (Test-Path $sshCfg) {
    if (-not (Select-String -Path $sshCfg -Pattern "Host github.com" -Quiet)) {
        Add-Content -Path $sshCfg -Value "`r`n$cfgText"
        Write-Host "Added GitHub entry to ~/.ssh/config"
    } else {
        Write-Host "~/.ssh/config already has a github.com entry."
    }
} else {
    Set-Content -Path $sshCfg -Value $cfgText
    Write-Host "Created ~/.ssh/config"
}

Write-Host "`n=== 3/4 agent-hub repo (over SSH) ===`n" -ForegroundColor Cyan
$hub = "C:\Users\jforsyth\agent-hub"
if (Test-Path (Join-Path $hub ".git")) {
    Write-Host "agent-hub already cloned. Updating remote to SSH + pulling..."
    Push-Location $hub
    & $git remote set-url origin "git@github.com:kampakilla007/agent-hub.git"
    & $git pull --ff-only
    Pop-Location
} else {
    Write-Host "Cloning agent-hub over SSH..."
    & $git clone "git@github.com:kampakilla007/agent-hub.git" $hub
}
Write-Host "agent-hub remote:" -ForegroundColor Gray
& $git -C $hub remote -v

Write-Host "`n=== 4/4 VPS SSH key ===`n" -ForegroundColor Cyan
$key = "C:\Users\jforsyth\.ssh\vps_key"
if (Test-Path $key) {
    Write-Host "VPS SSH key present: $key"
    Write-Host "Test connectivity (5s)..."
    & ssh -i $key -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 -o BatchMode=yes root@89.117.23.163 "echo VPS_OK && hostname && uname -a"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`nVPS reachable via SSH key. Good." -ForegroundColor Green
    } else {
        Write-Host "`nVPS SSH test failed (exit $LASTEXITCODE). Public IP may be firewalled; try Tailscale 100.104.79.55." -ForegroundColor Yellow
    }
} else {
    Write-Host "WARN: no vps_key. Obtain it before connecting." -ForegroundColor Yellow
}

Write-Host "`n=== DONE ===`n" -ForegroundColor Green
Write-Host "Next: read C:\Users\jforsyth\Downloads\project-status.md for full context,"
Write-Host "and C:\Users\jforsyth\Downloads\agent-onboarding.md for what-not-to-do."
Write-Host ""
Write-Host "If git push/pull shows 'Permission denied (publickey)', the GitHub key" -ForegroundColor Yellow
Write-Host "wasn't added (or not verified). Add $keyFile.pub at github.com/settings/ssh/new." -ForegroundColor Yellow
