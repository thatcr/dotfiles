

# controls poetry's colours, but breaks nox-poetry
#$Env:ANSICON = "1"

$Env:PYTHONNOUSERSITE = "1"

$Env:PRE_COMMIT_COLOR = "always"

$Env:PY_COLORS = "1"
$Env:PYTEST_ADDOPTS = "--tb short"

$Env:PIP_NO_PYTHON_VERSION_WARNING = "1"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = "1"

If ($IsWindows) {
    $Env:HOME = "$Env:USERPROFILE"
}

function Install-VS2015-Environment {
    [CmdletBinding()] param()
    Push-Location "${Env:PROGRAMFILES(x86)}\Microsoft Visual Studio 14.0\VC"

    cmd /c "vcvarsall.bat amd64 & SET" | ForEach-Object {
        if ($_ -match "=") {
            $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
        }
    }
    Pop-Location
    Write-Host "`nVisual Studio 2015 Command Prompt variables set." -ForegroundColor Yellow
}

# TODO use winget instead?
$ScoopPackages = (
    "7zip", "delta", "depends", "git", "greenshot", "Hack-NF", "Hack-NF-Mono",
    "pwsh", "pycharm", "ripgrep", "starship", "sudo", "sysinternals", "tokei", "windows-terminal",
    "azure-cli", "lf"
)

# Get-Process-From-Prefix | Stop-Process -Confirm
# NOTE no process owner from here?
function Get-Process-From-Prefix {
    [CmdletBinding()]param(
        [string]$Prefix = $Env:CONDA_PREFIX
    )
    Get-Process | Where-Object { ($null -ne $_.Path) -and $_.Path.StartsWith($Prefix) } | Format-Table -Property Id, CommandLine

    # use -IncludeUserName if admin
}

function Install-My-Stuff {
    [CmdletBinding()]param()

    Install-Module posh-git -Scope CurrentUser

    Get-Command scoop || {
        iwr -useb get.scoop.sh | iex
        scoop bucket add extras
        scoop bucket add nerd-fonts
        scoop install sudo
    }

    sudo scoop update sudo

    foreach ($Package in $ScoopPackages) {
        scoop install $Package
    }

    sudo scoop update --all
}

function rmrf {
    [CmdletBinding()]
    param(
        [string]$Path
    )
    Remove-Item -Force -Recurse -Path $Path
}

function cfg {
    git --git-dir $Env:HOME/.cfg --work-tree=$Env:HOME $Args
}

function setx {
    [CmdletBinding()]
    param(
        [string]$name,
        [string]$value
    )
    [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::User)
}

function which {
    [CmdletBinding()]
    param([string]$command)
    Get-Command -All -ShowCommandInfo $command | Format-Table -Property CommandType, Definition -AutoSize
}

function whois {
    [CmdletBinding()] param($userid)
    Get-AdUser -Identity $userid -Properties SamAccountName, DisplayName, extensionAttribute1, extensionAttribute2
}

# Add to the PATH on windows to find it?
# C:\Program Files\starship\bin\starship.exe

Invoke-Expression (& starship init powershell --print-full-init | Out-String)
Import-Module posh-git

# Initialise powershell with conda settings
(& "$Env:CONDA_EXE" "shell.powershell" "hook") | Out-String | Invoke-Expression
