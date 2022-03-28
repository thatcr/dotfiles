
$Env:PY_COLORS = "1"
# controls poetry's colours, but breaks nox-poetry
#$Env:ANSICON = "1"

$Env:PRE_COMMIT_COLOR = "always"
$Env:PYTEST_ADDOPTS = "--tb short"

$Env:HOME = "$Env:USERPROFILE"

$Env:PIP_NO_PYTHON_VERSION_WARNING = "1"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = "1"

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

function Install-My-Stuff {
    [CmdletBinding()]param()

    Get-Command scoop || {
        iwr -useb get.scoop.sh | iex
        scoop bucket add extras
        scoop bucket add nerd-fonts
    }

    scoop install ripgrep
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
    Get-Command -All -ShowCommandInfo $command
}


Invoke-Expression (&starship init powershell)
Import-Module posh-git