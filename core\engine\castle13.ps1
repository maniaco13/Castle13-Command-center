$script:Castle13Root = Split-Path (Split-Path $MyInvocation.MyCommand.Path -Parent) -Parent

# --- GLOBAL THEME ---
$Global:Castle13_Theme = @{
    Primary   = "Cyan"; Secondary = "White"; Accent = "Yellow"
    Muted     = "DarkGray"; Success = "Green"; Warning = "Magenta"; Failure = "Red"
}

# --- UI HELPER FUNCTIONS ---
function Show-SquadHeader([string]$Title) {
    Clear-Host; Write-Host "===`[ $Title `]===" -ForegroundColor $Global:Castle13_Theme.Accent
    Write-Host ("=" * 50) -ForegroundColor $Global:Castle13_Theme.Muted; Write-Host ""
}
function Show-SectionHeader([string]$Title) { Write-Host "`n--- $Title ---" -ForegroundColor $Global:Castle13_Theme.Primary }
function Show-Result([string]$Status, [string]$Message) {
    $color = switch ($Status) { "OK" { $Global:Castle13_Theme.Success } "WARN" { $Global:Castle13_Theme.Warning } "FAIL" { $Global:Castle13_Theme.Failure } "INFO" { $Global:Castle13_Theme.Primary } Default { $Global:Castle13_Theme.Secondary } }
    Write-Host "[$Status] " -NoNewline -ForegroundColor $color; Write-Host $Message -ForegroundColor $Global:Castle13_Theme.Secondary
}
function Show-SquadMenu([string]$Title, [array]$Options) {
    Write-Host "`n$Title OPTIONS:" -ForegroundColor $Global:Castle13_Theme.Primary
    for ($i = 0; $i -lt $Options.Count; $i++) {
        Write-Host "  [$($i+1)] " -NoNewline -ForegroundColor $Global:Castle13_Theme.Secondary
        Write-Host "$($Options[$i].Name)" -ForegroundColor $Global:Castle13_Theme.Secondary
        Write-Host "      $($Options[$i].Description)" -ForegroundColor $Global:Castle13_Theme.Muted
    }
    Write-Host "`n----------------------------------------" -ForegroundColor $Global:Castle13_Theme.Muted
    Write-Host "  [B] Back/Home" -ForegroundColor $Global:Castle13_Theme.Muted
    Write-Host "  [Q] Quit Castle 13" -ForegroundColor $Global:Castle13_Theme.Muted; Write-Host ""
}
function Request-Input([string]$Prompt) { Write-Host "$Prompt: " -NoNewline -ForegroundColor $Global:Castle13_Theme.Secondary; return (Read-Host) }
function Pause-Squad { Write-Host "`nPress Enter to continue..." -ForegroundColor $Global:Castle13_Theme.Muted; $null = Read-Host }
function Require-Castle13Dependency([string]$ToolName, [string]$SquadName) {
    if (Get-Command $ToolName -ErrorAction SilentlyContinue) { return $true }
    Show-Result -Status "FAIL" -Message "$ToolName is required for the $SquadName Squad."
    Pause-Squad; return $false
}

# --- THE MASSIVE REGISTRY ---
$script:Squads = @{
    "setup"       = @{ Name = "Setup"; Category = "SYSTEM"; Entry = "$script:Castle13Root\squads\system\setup.ps1"; Description = "Universal Installer" }
    "wsl"         = @{ Name = "WSL Ops"; Category = "SYSTEM"; Entry = "$script:Castle13Root\squads\system\wsl.ps1"; Description = "Linux Subsystem Manager" }
    "filemanager" = @{ Name = "File Manager"; Category = "SYSTEM"; Entry = "$script:Castle13Root\squads\system\filemanager.ps1"; Description = "Disk Space & Nav" }
    "ai"          = @{ Name = "Ollama"; Category = "DEVTOOLS"; Entry = "$script:Castle13Root\squads\devtools\ollama.ps1"; Description = "Local AI Ops" }
    "gemini"      = @{ Name = "Gemini Cloud"; Category = "DEVTOOLS"; Entry = "$script:Castle13Root\squads\devtools\gemini.ps1"; Description = "Google API (Placeholder)" }
    "builder"     = @{ Name = "Squad Builder"; Category = "DEVTOOLS"; Entry = "$script:Castle13Root\squads\devtools\builder.ps1"; Description = "Create new modules" }
    "homelab"     = @{ Name = "Homelab Ops"; Category = "NETWORK"; Entry = "$script:Castle13Root\squads\network\homelab.ps1"; Description = "Proxmox & Zenith Beats" }
    "network"     = @{ Name = "Net Tools"; Category = "NETWORK"; Entry = "$script:Castle13Root\squads\network\network.ps1"; Description = "General Ping/IPConfig" }
    "security"    = @{ Name = "Security Ops"; Category = "SECURITY"; Entry = "$script:Castle13Root\squads\security\security.ps1"; Description = "CTF & Sec+ Toolkit" }
}

# --- MAIN MENU LOOP ---
function Invoke-Castle13 {
    while ($true) {
        Show-SquadHeader "COMMAND CENTER"
        Write-Host "  ACTIVE SQUADS:" -ForegroundColor $Global:Castle13_Theme.Primary
        $i = 1; $menuMap = @{}
        foreach ($key in $script:Squads.Keys | Sort-Object) {
            $squad = $script:Squads[$key]
            Write-Host "  [$i] $($squad.Name.PadRight(15)) - $($squad.Description)" -ForegroundColor $Global:Castle13_Theme.Secondary
            $menuMap[$i] = $squad; $i++
        }
        Write-Host "`n  [Q] Quit System" -ForegroundColor $Global:Castle13_Theme.Muted; Write-Host ""
        
        $choice = Request-Input "Initialize Squad"
        if ($choice.ToUpper() -eq 'Q') { break }
        
        if ($choice -match '^\d+$' -and $menuMap.ContainsKey([int]$choice)) {
            $selected = $menuMap[[int]$choice]
            if (Test-Path $selected.Entry) {
                . $selected.Entry
                $funcName = "Invoke-$($selected.Name -replace ' ', '')"
                if (Get-Command $funcName -ErrorAction SilentlyContinue) { & $funcName } 
                else { Show-Result -Status "FAIL" -Message "Function $funcName not found."; Pause-Squad }
            } else { Show-Result -Status "FAIL" -Message "Module missing at $($selected.Entry)"; Pause-Squad }
        }
    }
}
Invoke-Castle13
