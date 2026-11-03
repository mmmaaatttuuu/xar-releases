[CmdletBinding()]
param(
    [string]$PublicDirectory = (Join-Path $env:LOCALAPPDATA 'XAR\desktop\app-native\2.0.5\app\public')
)

$ErrorActionPreference = 'Stop'
$utf8 = [System.Text.UTF8Encoding]::new($false)
$publicPath = (Resolve-Path -LiteralPath $PublicDirectory).Path
$appPath = Join-Path $publicPath 'app.js'
$stylePath = Join-Path $publicPath 'style.css'
$modulePath = Join-Path $publicPath 'notification-ui.js'
$moduleSource = Join-Path $PSScriptRoot 'notification-ui.js'
$styleSource = Join-Path $PSScriptRoot 'notification-ui.css'

foreach ($required in @($appPath, $stylePath, $moduleSource, $styleSource)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) {
        throw "Required file missing: $required"
    }
}

$app = [System.IO.File]::ReadAllText($appPath)
$style = [System.IO.File]::ReadAllText($stylePath)
$module = [System.IO.File]::ReadAllText($moduleSource)
$notificationStyle = [System.IO.File]::ReadAllText($styleSource).Trim()
$anchor = "import './desktop-ui.js';"
$import = "import './notification-ui.js';"
if (-not $app.Contains($anchor)) {
    throw 'This XAR layout is unsupported. No files were changed.'
}
if (-not $notificationStyle.Contains('#xar-source-review') -or
    -not $module.Contains('function enhanceSourceNotice()')) {
    throw 'Notification patch files are incomplete. No files were changed.'
}

$nextApp = $app
if (-not $app.Contains($import)) {
    $nextApp = $app.Replace($anchor, "$anchor`n$import")
}
$nextStyle = $style
if (-not $style.Contains($notificationStyle)) {
    $nextStyle = "$style`n`n$notificationStyle`n"
}
if ($nextApp -ceq $app -and $nextStyle -ceq $style -and
    (Test-Path -LiteralPath $modulePath) -and
    [System.IO.File]::ReadAllText($modulePath) -ceq $module) {
    Write-Output 'The notification update is already installed.'
    return
}

# Back up only the affected UI files. No chats, credentials, or workspace data.
$backup = Join-Path $publicPath ('.notification-backup-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $backup | Out-Null
$existing = @($appPath, $stylePath)
if (Test-Path -LiteralPath $modulePath) { $existing += $modulePath }
foreach ($path in $existing) {
    Copy-Item -LiteralPath $path -Destination (Join-Path $backup ([System.IO.Path]::GetFileName($path)))
}

$writes = @(
    @{ Path = $modulePath; Content = $module },
    @{ Path = $stylePath; Content = $nextStyle },
    @{ Path = $appPath; Content = $nextApp }
)
try {
    foreach ($write in $writes) {
        $temporary = $write.Path + '.notification-tmp-' + [guid]::NewGuid().ToString('N')
        [System.IO.File]::WriteAllText($temporary, $write.Content, $utf8)
        Move-Item -LiteralPath $temporary -Destination $write.Path -Force
    }
} catch {
    foreach ($path in $existing) {
        Copy-Item -LiteralPath (Join-Path $backup ([System.IO.Path]::GetFileName($path))) -Destination $path -Force
    }
    throw "The update failed; original files were restored. Backups: $backup. $($_.Exception.Message)"
}
Write-Output "Notification update installed. Backups: $backup"
Write-Output 'Reload XAR with Ctrl+R, or close and reopen it.'
