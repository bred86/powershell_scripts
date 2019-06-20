$fb_version = "6.5.4"

# #########################
# Download Filebeat
# #########################
Write-Host "Downloading Filebeat $fb_version"
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
Invoke-WebRequest -Uri "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$fb_version-windows-x86_64.zip" `
                  -OutFile "C:\Users\Administrator\Downloads\filebeat-$fb_version-windows-x86_64.zip"

# #########################
# Stop Filebeat's service
# #########################
Write-Host "Stopping Filebeat Service"
Stop-Service filebeat

# #########################
# Backup the current configuration
# #########################
Write-Host "Backing up configuration"
Copy-Item "C:\filebeat\filebeat.yml" -Destination "C:\Users\Administrator\Documents\filebeat.yml"

# #########################
# Removes everytyhing related to the current Filebeat
# #########################
Write-Host "Removing old Filebeat"
Invoke-Expression "C:\filebeat\uninstall-service-filebeat.ps1"
if ($?) {
  get-childitem "C:\filebeat\*" -Recurse | Remove-item -Force

  if ((Test-Path "C:\ProgramData\filebeat\Logs") -eq 1) {
    get-childitem "C:\ProgramData\filebeat\Logs\*" -Recurse | Remove-item -Force
  }
  get-childitem "C:\ProgramData\filebeat\*" -Recurse | Remove-item -Force
  New-Item -ItemType Directory -path "C:\ProgramData\filebeat\logs"
  Remove-Item "C:\filebeat\"
  Write-Host "Filebeat Removed"
}
else
{
  Write-Host "Cant remove Filebeat"
  exit 2
}

# #########################
# Extracts the new Filebeat and renames the directory
# #########################
Write-Host "Unziping Filebeat"
Expand-Archive "C:\Users\Administrator\Downloads\filebeat-$fb_version-windows-x86_64.zip" -OutputPath "C:\"
Rename-Item "C:\filebeat-$fb_version-windows-x86_64" "C:\filebeat"

# #########################
# Restores the configuration
# #########################
Write-Host "Restoring configuration"
Copy-Item "C:\Users\Administrator\Documents\filebeat.yml" -Destination "C:\filebeat\filebeat.yml"

# #########################
# Installs Filebeat
# #########################
Write-Host "Install Filebeat"
Invoke-Expression "C:\filebeat\install-service-filebeat.ps1"
if ($?) {
  Write-Host "Filebeat installed"
}
else
{
  Write-Host "Cant install Filebeat"
  exit 2
}

# #########################
# Start Filebeat's service
# #########################
Write-Host "Statrt Filebeat Service"
Start-Service filebeat
