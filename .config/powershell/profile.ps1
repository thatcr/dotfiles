$Env:PY_COLORS = "1"

$Env:PIP_NO_PYTHON_VERSION_WARNING = "1"
$Env:PIP_DISABLE_PIP_VERSION_CHECK = "1"

If ($IsWindows) {
    $Env:HOME = "$Env:USERPROFILE"
}
function pt {
    & pytest --stepwise --maxfail 1 -s -l -rN --tb=native --log-cli-level=DEBUG --log-level=ERROR -p no:cov --disable-warnings
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
    Write-Host "Visual Studio 2015 Command Prompt variables set." -ForegroundColor Yellow
}

# TODO use winget instead?
$ScoopPackages = (
    "7zip", "delta", "depends", "Hack-NF-Mono",
    "pwsh", "pycharm", "ripgrep",  "sudo",  "tokei",
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

function excel {
    $Excel = "$Env:ProgramFiles\Microsoft Office\Root\Office16\EXCEL.EXE"
    Start-Process -FilePath $Excel -ArgumentList @Args
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

function ntids {
    [CmdletBinding()] param($userid)
    Get-AdUser -Filter "Surname -like '$Surname*'"
}

function adgroups {
    [CmdletBinding()] param($userid)
    Get-AdPrincipalGroupMembership tungm2 | select name
}

# this is pretty quick
Invoke-Expression (& starship init powershell --print-full-init | Out-String)

# if Env:CONDA is set then setup the pwsh hooks
If (Test-Path -Path "$Env:CONDA" -PathType Container) {
    (& "$Env:CONDA\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | Invoke-Expression
}