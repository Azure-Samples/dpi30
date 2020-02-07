# Script to install Self hosted Integration Runtime and SSMS on the VM
# Based on script from: https://gist.github.com/justinsoliz/34324700ea93c7b77b4ac3e132584de7
# Set file and folder path for SSMS installer .exe
$folderpath = "C:\Windows\Temp"

# SSMS Install
$filepath = "$folderpath\SSMS-Setup-ENU.exe"
 
#If SSMS not present, download
if (!(Test-Path $filepath)) {
    write-host "Downloading SSMS..."
    $URL = "https://aka.ms/ssmsfullsetup"
    $clnt = New-Object System.Net.WebClient
    $clnt.DownloadFile($url, $filepath)
    Write-Host "SSMS installer download complete" -ForegroundColor Green
 
}
else {
 
    write-host "Located the SSMS Installer binaries, moving on to install..."
}
 
# start the SSMS installer
write-host "Beginning SSMS install..." -nonewline
$Parms = " /Install /Quiet /Norestart /Logs ssmslog.txt"
$Prms = $Parms.Split(" ")
& "$filepath" $Prms | Out-Null
Write-Host "SSMS installation complete" -ForegroundColor Green

# Self Hosted Integration Runtime Install
$filepath = "$folderpath\IntegrationRuntime.msi"
 
#If SSMS not present, download
if (!(Test-Path $filepath)) {
    write-host "Downloading Integration Runtime..."
    $URL = "https://download.microsoft.com/download/E/4/7/E4771905-1079-445B-8BF9-8A1A075D8A10/IntegrationRuntime_4.4.7292.1.msi"
    $clnt = New-Object System.Net.WebClient
    $clnt.DownloadFile($url, $filepath)
    Write-Host "Integration Runtime download complete" -ForegroundColor Green
}
else {
    write-host "Located the Integration Runtime Installer binaries, moving on to install..."
}
 
# start the SSMS installer
write-host "Beginning Integration Runtime install..." -nonewline
$Parms = "/i $filepath /qn /norestart /l*v shirlog.txt"
Start-Process msiexec.exe -Wait -ArgumentList $Parms | Out-Null
Write-Host "Integration Runtime installation complete" -ForegroundColor Green