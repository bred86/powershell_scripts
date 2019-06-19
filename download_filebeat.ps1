Write-Host "Downloading Filebeat 6.5.4"
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
Invoke-WebRequest -Uri "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.5.4-windows-x86_64.zip" `
                  -OutFile "C:\Users\Administrator\Downloads\filebeat-6.5.4-windows-x86_64.zip"

Write-Host "Stopping Filebeat Service"
Stop-Service filebeat

Write-Host "Backing up configuration"
Copy-Item "C:\filebeat\filebeat.yml" `
                  -Destination "C:\Users\Administrator\Documentsfilebeat.yml"

Write-Host "Unziping Filebeat"
Expand-Archive "C:\User\Administrator\Downloads\filebeat-6.5.4-windows-x86_64.zip" -DestinationPath "C:\"

Write-Host "Installing Filebeat"
Invoke-Item (start powershell ((Split-Path $MyInvocation.InvocationName) + "\b.ps1"))

Write-Host ""
