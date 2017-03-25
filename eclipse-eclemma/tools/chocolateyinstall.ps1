# Unzip to eclipse folder
$packageArgs = @{
  packageName   = $env:chocolateyPackageName
  unzipLocation = (Join-Path $env:chocolateyPackageFolder "eclipse")

  url           = "http://download.eclipselab.org/eclemma/release/eclemma-${env:chocolateyPackageVersion}.zip"
  checksum      = 'a5ec12fda5389fcf4a22ed63a17d1f11'
  checksumType  = 'md5'
}

Install-ChocolateyZipPackage @packageArgs

# Only keep the plugins folder
Get-ChildItem -Path (Join-Path $env:chocolateyPackageFolder "eclipse") -Recurse |
  Select -ExpandProperty FullName |
  Where { $_ -notlike (Join-Path $env:chocolateyPackageFolder "eclipse\plugins") + "*" } |
  Sort length -Descending |
  Remove-Item -Force

# Create link file in dropins
("path=" + $env:chocolateyPackageFolder ) -replace '\\', '/' | Out-File  -Encoding ASCII (Join-Path $env:ChocolateyInstall "lib/eclipse/eclipse/dropins/${env:chocolateyPackageName}.link")
