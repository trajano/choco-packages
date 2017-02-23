. "$env:chocolateyPackageFolder/tools/globals.ps1"

# Just extract to the package folder because the zip file will have everything inside "eclipse" directory.
$packageArgs = @{
  packageName   = $env:chocolateyPackageName
  unzipLocation = $env:chocolateyPackageFolder
  softwareName  = 'eclipse*'

  url           = 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/2/eclipse-jee-neon-2-win32.zip&r=1'
  checksum      = '958b5c0a6cfce8d8db31b617bb1196a74978ea7d522aeddc7a0952b61f38b7ee574d7e1af830eff03d5785ec04d16fb1f4257dc6ce379ccfe7ef053ecaa37b2b'
  checksumType  = 'sha512'

  url64bit      = 'https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/neon/2/eclipse-jee-neon-2-win32-x86_64.zip&r=1'
  checksum64    = '2d13569d6ad2df257ca01713e3a90486fe3c2c09fc569da9781532eca88a12c4c82104d15de47cbef93506c5d090d28a677900e5d9ae0d0e916623571c073c1b'
  checksumType64= 'sha512'
}

Install-ChocolateyZipPackage @packageArgs

$eclipseFolder = Join-Path $env:chocolateyPackageFolder 'eclipse'
# Do not create shims except for eclipse.exe
foreach ($file in get-childitem  $eclipseFolder -include *.exe -exclude eclipse.exe -recurse) {
  #generate an ignore file
  New-Item "$file.ignore" -type file -force | Out-Null
}

# Update the eclipse.ini so it has the JAVA_HOME which is set by `jdk`
$eclipseIni = Join-Path $eclipseFolder "eclipse.ini"
$eclipseIniContents = Get-content $eclipseIni
Remove-Item $eclipseIni

foreach ($line in $eclipseIniContents) {
  if ($line -eq "-vmargs") {
    # found vmargs line so stop here and add the vm line before it
    Add-Content -Path $eclipseIni -Value "-vm"
    Add-Content -Path $eclipseIni -Value "$env:JAVA_HOME/jre/bin/server/jvm.dll"
  }
  Add-Content -Path $eclipseIni -Value $line
}

Install-ChocolateyShortcut  -ShortcutFilePath $shortcut -TargetPath (Join-Path $eclipseFolder "eclipse.exe")
# DO NOT -PinToTaskbar true because using that shortcut will create a second taskbar icon
