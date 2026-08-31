# ============================================================
#  CPUVETS / BITCLOUD NEW-AGENT BOOTSTRAP  (Windows / PowerShell)
#  Device: lpt-aw1 / aw-pc2025  (user: jorsyth)
#  Sets up:
#    (1) Git + the agent-hub repo (via per-device SSH key)
#    (2) The public VPS (89.117.23.163) over SSH
#  Per-device GitHub SSH key: each machine gets its OWN key so
#  no PAT is shared. You must add the printed public key to
#  GitHub before git push/pull will work.
# ============================================================

$ErrorActionPreference = "Stop"

$git = "C:\Program Files\Git\cmd\git.exe"
$gitSsh = "C:\Program Files\Git\usr\bin\ssh.exe"
$sshKeyFile = "$env:USERPROFILE\.ssh\github_key"
$sshDir = "$env:USERPROFILE\.ssh"
$knownHosts = "$sshDir\known_hosts"

# --- Working SSH wrapper (Git for Windows' bundled SSH, no-PATH-space issues) ---
$wrapper = "$sshDir\git-ssh.cmd"
if (Test-Path $gitSsh) {
    if (-not (Test-Path $wrapper)) {
        Set-Content -Path $wrapper -Value "@echo off`r`n`"$gitSsh`" %*" -Encoding ASCII
        Write-Host "Created SSH wrapper: $wrapper"
    }
}

Write-Host "`n=== 1/4 Verifying Git ===`n" -ForegroundColor Cyan
if (Test-Path $git) {
    Write-Host "git found: $git"
    & $git --version
} else {
    Write-Host "ERROR: git not found at $git. Install Git, then re-run." -ForegroundColor Red
    exit 1
}

Write-Host "`n=== 2/4 GitHub auth (per-device SSH key) ===`n" -ForegroundColor Cyan

# 2a. Set git identity + use the working SSH wrapper (avoids system-OpenSSH KEX issue)
& $git config --global user.email "jforsyth32@gmail.com"
& $git config --global user.name  "jforsyth32"
& $git config --global core.autocrlf false
& $git config --global init.defaultBranch main
& $git config --global core.sshCommand "C:/Users/jorsyth/.ssh/git-ssh.cmd"

# 2b. Ensure ~/.ssh exists
if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir | Out-Null
    Write-Host "Created $sshDir"
}

# 2c. Generate a per-device GitHub SSH key if none exists
if (-not (Test-Path $sshKeyFile)) {
    Write-Host "No existing GitHub SSH key. Generating a NEW per-device key..." -ForegroundColor Yellow
    ssh-keygen -t ed25519 -C "jforsyth32@gmail.com" -f $sshKeyFile -N """"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: ssh-keygen failed. Is OpenSSH client installed?" -ForegroundColor Red
        exit 1
    }
    Write-Host ""
    Write-Host "=== ADD THIS PUBLIC KEY TO GITHUB (once per device) ===" -ForegroundColor Green
    Write-Host "Open  https://github.com/settings/ssh/new  and paste:" -ForegroundColor Cyan
    Write-Host ""
    Get-Content "$sshKeyFile.pub"
    Write-Host ""
    Write-Host "Title it e.g. 'laptop-<name>'. After adding, re-run this script" -ForegroundColor Cyan
    Write-Host "(or 'ssh -T git@github.com' to test) - do NOT reuse another device's key." -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Host "GitHub SSH key already present: $sshKeyFile (per-device)."
}

# 2d. Ensure SSH config points GitHub at the key
$sshCfg = "$sshDir\config"
$cfgText = @"
Host github.com
  HostName github.com
  User git
  IdentityFile $sshKeyFile
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

# 2e. Pre-seed github.com host key using git's ssh (system ssh lacks modern KEX)
if (Test-Path $gitSsh) {
    $prev = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $ga = & $gitSsh -o StrictHostKeyChecking=accept-new -o UserKnownHostsFile=$knownHosts -T git@github.com 2>&1 | Out-String
    $ErrorActionPreference = $prev
    if ("$ga" -match "successfully authenticated") {
        Write-Host "GitHub SSH auth verified." -ForegroundColor Green
    } elseif ("$ga" -match "Permission denied") {
        Write-Host "WARN: GitHub auth not yet working. Add $sshKeyFile.pub to github.com/settings/ssh/new" -ForegroundColor Yellow
    } else {
        Write-Host "github.com host key pre-seeded in known_hosts."
    }
}

Write-Host "`n=== 3/4 agent-hub repo (over SSH) ===`n" -ForegroundColor Cyan
$hub = "C:\Users\jorsyth\agent-hub"
if (Test-Path (Join-Path $hub ".git")) {
    Write-Host "agent-hub already cloned. Updating remote to SSH + pulling..."
    & $git -C $hub remote set-url origin "git@github.com:kampakilla007/agent-hub.git"
    & $git -C $hub pull --ff-only
} else {
    if (-not (Test-Path $hub)) { New-Item -ItemType Directory -Path $hub | Out-Null; Remove-Item $hub -Force }
    Write-Host "Cloning agent-hub over SSH..."
    & $git clone "git@github.com:kampakilla007/agent-hub.git" $hub
}
Write-Host "agent-hub remote:" -ForegroundColor Gray
& $git -C $hub remote -v

Write-Host "`n=== 4/4 VPS SSH key ===`n" -ForegroundColor Cyan
$key = "$sshDir\vps_key"
if (Test-Path $key) {
    Write-Host "VPS SSH key present: $key"
    Write-Host "Test connectivity (public IP, 8s)..."
    if (Test-Path $gitSsh) {
        & $gitSsh -i $key -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 -o BatchMode=yes -o UserKnownHostsFile=$knownHosts root@89.117.23.163 "echo VPS_OK && hostname && uname -a"
    } else {
        & ssh -i $key -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 -o BatchMode=yes root@89.117.23.163 "echo VPS_OK && hostname && uname -a"
    }
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`nVPS reachable via SSH key. Good." -ForegroundColor Green
    } else {
        Write-Host "`nVPS SSH test failed (exit $LASTEXITCODE). Public IP may be firewalled; try Tailscale 100.104.79.55." -ForegroundColor Yellow
        & $gitSsh -i $key -o StrictHostKeyChecking=accept-new -o ConnectTimeout=8 -o BatchMode=yes -o UserKnownHostsFile=$knownHosts root@100.104.79.55 "echo VPS_OK && hostname && uname -a"
        if ($LASTEXITCODE -eq 0) { Write-Host "`nVPS reachable via Tailscale." -ForegroundColor Green }
    }
} else {
    Write-Host "WARN: no vps_key. Generate one and add its public key to /root/.ssh/authorized_keys on the VPS." -ForegroundColor Yellow
}

Write-Host "`n=== DONE ===`n" -ForegroundColor Green
Write-Host "Next: read C:\Users\jorsyth\Downloads\project-status.md for full context,"
Write-Host "and C:\Users\jorsyth\Downloads\agent-onboarding.md for what-not-to-do."
Write-Host ""
Write-Host "If git push/pull shows 'Permission denied (publickey)', the GitHub key" -ForegroundColor Yellow
Write-Host "wasn't added (or not verified). Add $sshKeyFile.pub at github.com/settings/ssh/new." -ForegroundColor Yellow
