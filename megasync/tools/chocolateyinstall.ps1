$packageArgs = @{
    packageName   = $env:chocolateyPackageName
    url = 'https://mega.nz/MEGAsyncSetup.exe'
    checksum      = '1A09A281EAB406B353514F71B4D83178E7820915DDD9978AA75F89A0E01F9B11'
    checksumType  = 'sha256'
    silentArgs = "/S"
}
Install-ChocolateyPackage @packageArgs
