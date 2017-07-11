. "$env:chocolateyPackageFolder/tools/globals.ps1"

# Just extract to the package folder because the zip file will have everything inside "eclipse" directory.
$packageArgs = @{
  packageName   = $env:chocolateyPackageName
  unzipLocation = $env:chocolateyPackageFolder
  softwareName  = 'eclipse*'

  url           = 'http://download.eclipse.org/technology/epp/downloads/release/oxygen/R/eclipse-jee-oxygen-R-win32.zip'
  checksum      = 'd6410343b13f21e5c9aa034d2f290a54b023dc959a685cb376c7928a540c4c397aa66e8c2c4bf690e620883fbcbcb5059066252079c83339d4692b337458bac7'
  checksumType  = 'sha512'

  url64bit      = 'http://download.eclipse.org/technology/epp/downloads/release/oxygen/R/eclipse-jee-oxygen-R-win32-x86_64.zip'
  checksum64    = '43838d488c2f1f64c36f0a0c0672b2554a46eca6a462d6a0a14c5340dd10bc3827385828149d277d61fcd7afe9538b4af68c860bec61f390641480ce4ae10452'
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
