# Allow running scripts
Set-ExecutionPolicy Bypass -Scope Process -Force

[System.Net.ServicePointManager]::SecurityProtocol = 'Tls12'

# Install Chocolatey
if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Output "Installing Chocolatey..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Output "Chocolatey already installed."
}

# Install tools
choco install git -y
choco install python -y
choco install nodejs -y
choco install dotnet-sdk -y
choco install openjdk17 -y

# Save versions
$versionInfo = @()
$versionInfo += "Git: $(git --version)"
$versionInfo += "Python: $(python --version)"
$versionInfo += "Node: $(node -v)"
$versionInfo += ".NET: $(dotnet --version)"
$versionInfo += "Java: $(java -version 2>&1)"

Set-Content -Path "C:\installed_versions.txt" -Value $versionInfo
