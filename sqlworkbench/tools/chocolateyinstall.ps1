. "$env:chocolateyPackageFolder/tools/globals.ps1"

$packageArgs = @{
  packageName   = $env:chocolateyPackageName
  unzipLocation = $env:chocolateyPackageFolder

  url           = 'http://www.sql-workbench.net/Workbench-Build${env:chocoPackageVersion}.zip'
  checksum      = '97A7C5628C0F18FFCDBD624D932F25E28DB1901CB6DCD1D6468D8311089777FE64E157FAB44FAE64B14FA98C503210471FE60B93348C5977F1A61EA653BF6D2E'
  checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs

# Only keep the one for the architecture needed
if (Get-OSArchitectureWidth -Compare 32) {
    Remove-Item (Join-Path $env:chocolateyPackageFolder 'SQLWorkbench64.exe')
    Remove-Item (Join-Path $env:chocolateyPackageFolder 'sqlwbconsole64.exe')
}

if (Get-OSArchitectureWidth -Compare 64) {
    Remove-Item (Join-Path $env:chocolateyPackageFolder 'sqlwbconsole.exe')
    Rename-Item (Join-Path $env:chocolateyPackageFolder "sqlwbconsole64.exe") "sqlwbconsole.exe"
    Remove-Item (Join-Path $env:chocolateyPackageFolder 'SQLWorkbench.exe')
    Rename-Item (Join-Path $env:chocolateyPackageFolder "SQLWorkbench64.exe") "SQLWorkbench.exe"
}

Install-ChocolateyShortcut  -ShortcutFilePath $shortcut -TargetPath (Join-Path $env:chocolateyPackageFolder 'SQLWorkbench.exe') -PinToTaskbar
