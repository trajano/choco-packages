# Just extract to the package folder because the zip file will have everything inside "release" directory.
$packageArgs = @{
  packageName   = $env:chocolateyPackageName
  unzipLocation = $env:chocolateyPackageFolder

  url           = 'http://www.graphviz.org/pub/graphviz/stable/windows/graphviz-2.38.zip'
  checksum      = '660d7e11cfac073b396ecca46f3bbabda123d84735b83b0f526896053c2a9f0254aac26691b85b37a22ba50868e1c626c7ffa7489d15ac32af5e37a0c71e3869'
  checksumType  = 'sha512'
}

Install-ChocolateyZipPackage @packageArgs
