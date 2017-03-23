$packageArgs = @{
    packageName   = $env:chocolateyPackageName
    url = "https://downloads.corsair.com/download?item=Files/CUE/CorsairUtilityEngineSetup_${env:chocolateyPackageVersion}_release.msi"
    fileType = 'msi'
    checksum      = ''
    checksumType  = 'sha256'
    silentArgs = "/QUIET /NORESTART"
}
Install-ChocolateyPackage @packageArgs

# Start CUE2 since it won't automatically start up after install.
Start-Process (Join-Path (Get-AppInstallLocation "Corsair Utility Engine") "CUE.exe") -WindowStyle Hidden
