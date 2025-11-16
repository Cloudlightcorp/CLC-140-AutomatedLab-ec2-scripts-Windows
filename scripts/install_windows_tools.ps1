<powershell>

Start-Transcript -Path "C:\install_log.txt"

Write-Output "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force

[System.Net.ServicePointManager]::SecurityProtocol = "tls12"
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# FORCE chocolatey path for SYSTEM account
$choco = "C:\ProgramData\chocolatey\bin\choco.exe"

Write-Output "Installing Git..."
& $choco install git -y

Write-Output "Installing Node.js..."
& $choco install nodejs -y

Write-Output "Installing Python..."
& $choco install python -y

Write-Output "Installing JDK 17..."
& $choco install microsoft-openjdk17 -y

Write-Output "Installing VS Code..."
& $choco install vscode -y

Write-Output "Installing Postman..."
& $choco install postman -y

Write-Output "Installing .NET 6 SDK..."
& $choco install dotnet-6.0-sdk -y

Write-Output "DONE - all tools installed."
Stop-Transcript

</powershell>
