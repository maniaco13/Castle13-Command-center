function Invoke-Setup {
    while ($true) {
        Show-SquadHeader "UNIVERSAL INSTALLER"
        $options = @(
            @{ Name = "Fix Missing Tool"; Description = "Winget search and install" }
            @{ Name = "Refresh Environment"; Description = "Reload PATH" }
        )
        Show-SquadMenu -Title "DEPENDENCY OPS" -Options $options
        $choice = Request-Input "Select"
        switch ($choice.ToUpper()) { "B" { return } "Q" { exit } "1" { Invoke-FixMissingTool } "2" { Update-Environment; Pause-Squad } }
    }
}
function Invoke-FixMissingTool {
    $toolName = Request-Input "Enter tool name"
    if (-not $toolName) { return }
    if (Get-Command $toolName -ErrorAction SilentlyContinue) { Show-Result -Status "OK" -Message "Installed."; Pause-Squad; return }
    $search = winget search $toolName --source winget
    if ($LASTEXITCODE -eq 0) {
        $search | Select-Object -First 5 | ForEach-Object { Write-Host $_ }
        $id = Request-Input "Enter ID to install (C to cancel)"
        if ($id -ne 'C') { winget install $id; Update-Environment }
    }
    Pause-Squad
}
function Update-Environment { $env:Path = "$([Environment]::GetEnvironmentVariable("Path","Machine"));$([Environment]::GetEnvironmentVariable("Path","User"))" }
