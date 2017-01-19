$bcSetupUrl = 'http://www.scootersoftware.com/BCompare-4.1.3.20814.exe'
$bcSetup = "${env:Temp}\BCompare-4.1.3.20814.exe"

try
{
    Invoke-WebRequest -Uri $bcSetupUrl -OutFile $bcSetup
}
catch
{
    Write-Error "Failed to download BeyondCompare 4 Setup"
}

try
{
    Start-Process -FilePath $bcSetup
}
catch
{
    Write-Error 'Failed to install BeyondCompare 4'
}