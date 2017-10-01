. "$env:chocolateyPackageFolder/tools/globals.ps1"

# Just extract to the package folder because the zip file will have everything inside "eclipse" directory.
$packageArgs = @{
  packageName   = $env:chocolateyPackageName
  unzipLocation = $env:chocolateyPackageFolder
  softwareName  = 'eclipse*'

  url           = 'http://download.eclipse.org/technology/epp/downloads/release/oxygen/1/eclipse-jee-oxygen-1-win32.zip'
  checksum      = '3f40b7061f693edd7b73a021610ebb121ca776b8cc2fe5aa19b5d3d107651ee57d122e5c6b280e95492b3bfee36efc7870ca64e15b2fccc9ed53ae7a2da564ef'
  checksumType  = 'sha512'

  url64bit      = 'http://download.eclipse.org/technology/epp/downloads/release/oxygen/1/eclipse-jee-oxygen-1-win32-x86_64.zip'
  checksum64    = '65f3dac56406c506bb719538cc3395b18ab0e71a0352170ad77a311d1c5cdb431254c688a1ee79f138bd746ac7560386873ba74037cab1710bc5172cc9d1731a'
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
