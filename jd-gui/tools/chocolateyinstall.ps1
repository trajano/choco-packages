. "$env:chocolateyPackageFolder/tools/globals.ps1"

$packageArgs = @{
  packageName   = $env:chocolateyPackageName
  unzipLocation = $env:chocolateyPackageFolder

  url           = "https://github.com/java-decompiler/jd-gui/releases/download/v${env:chocolateyPackageVersion}/jd-gui-windows-${env:chocolateyPackageVersion}.zip"
  checksum      = ''
  checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs

Install-ChocolateyShortcut  -ShortcutFilePath $shortcut -TargetPath (Join-Path $env:chocolateyPackageFolder 'jd-gui.exe') -PinToTaskbar
