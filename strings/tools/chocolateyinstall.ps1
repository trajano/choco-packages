# Just extract to the package folder there is only one file because the 32-bit one will be removed if we are on a 64-bit machine
$packageArgs = @{
    packageName   = $env:chocolateyPackageName
    unzipLocation = $env:chocolateyPackageFolder

    url           = 'https://download.sysinternals.com/files/Strings.zip'
    checksum      = ''
    checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs

if (Get-OSArchitectureWidth -Compare 32) {
    Remove-Item (Join-Path $env:chocolateyPackageFolder 'strings64.exe')
}

if (Get-OSArchitectureWidth -Compare 64) {
    Remove-Item (Join-Path $env:chocolateyPackageFolder 'strings.exe')
    Rename-Item (Join-Path $env:chocolateyPackageFolder "strings64.exe") "strings.exe"
}
