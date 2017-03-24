# Unzip to eclipse folder
$packageArgs = @{
  packageName   = $env:chocolateyPackageName
  unzipLocation = (Join-Path $env:chocolateyPackageFolder "eclipse")

  url           = "https://github.com/java-decompiler/jd-eclipse/releases/download/v${env:chocolateyPackageVersion}/jd-eclipse-site-${env:chocolateyPackageVersion}-RC2.zip"
  checksum      = ''
  checksumType  = 'md5'
}

Install-ChocolateyZipPackage @packageArgs

# Only keep theplugins folder
Remove-Item (Join-Path $env:chocolateyPackageFolder "eclipse\*") -Recurse -Exclude "plugins"

# Create link file in dropins
("path=" + $env:chocolateyPackageFolder ) -replace '\\', '/' | Out-File  -Encoding ASCII (Join-Path $env:ChocolateyInstall "lib/eclipse/eclipse/dropins/${env:chocolateyPackageName}.link")
