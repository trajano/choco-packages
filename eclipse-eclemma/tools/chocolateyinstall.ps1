# Unzip to eclipse folder
$packageArgs = @{
  packageName   = $env:chocolateyPackageName
  unzipLocation = (Join-Path $env:chocolateyPackageFolder "eclipse")

  url           = "http://download.eclipselab.org/eclemma/release/eclemma-${env:chocolateyPackageVersion}.zip"
  checksum      = 'a5ec12fda5389fcf4a22ed63a17d1f11'
  checksumType  = 'md5'
}

Install-ChocolateyZipPackage @packageArgs

# Only keep theplugins folder
Remove-Item (Join-Path $env:chocolateyPackageFolder "eclipse\*") -Recurse -Exclude "plugins"

# Create link file in dropins
("path=" + $env:chocolateyPackageFolder ) -replace '\\', '/' | Out-File  -Encoding ASCII (Join-Path $env:ChocolateyInstall "lib/eclipse/eclipse/dropins/${env:chocolateyPackageName}.link")
