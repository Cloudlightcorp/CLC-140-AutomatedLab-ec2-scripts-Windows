<powershell>

# Logging
Start-Transcript -Path "C:\install_log.txt"

Write-Host "Installing Windows tools..."

# Install winget (preinstalled usually)
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile "winget.msixbundle"
Add-AppxPackage -Path "winget.msixbundle"

# Install Git
winget install --id Git.Git -e --source winget -h

# Install Java 17 (Temurin)
winget install --id EclipseAdoptium.Temurin.17.JDK -e --source winget -h

# Install Node.js LTS
winget install --id OpenJS.NodeJS.LTS -e --source winget -h

# Install Python 3.9
winget install --id Python.Python.3.9 -e --source winget -h

# Install .NET SDK
winget install --id Microsoft.DotNet.SDK.6 -e --source winget -h

# Install Google Chrome
winget install --id Google.Chrome -e --source winget -h

# Install VS Code
winget install --id Microsoft.VisualStudioCode -e --source winget -h

Write-Host "Writing versions to file..."
$versions = @"
Git: $(git --version)
Java: $(java --version)
Node: $(node --version)
Python: $(python --version)
DotNet: $(dotnet --version)
"@

Set-Content -Path "C:\installed_versions.txt" -Value $versions

Stop-Transcript
</powershell>
