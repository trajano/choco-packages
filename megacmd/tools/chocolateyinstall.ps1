# Rather than use the installer, unzip the file instead so that the shims will get created properly.
$packageArgs = @{
    packageName   = $env:chocolateyPackageName
    unzipLocation = $env:chocolateyPackageFolder
    url = 'https://mega.nz/MEGAcmdSetup.exe'
    checksum      = '350320ca4a9d2e4ee8be4e6d9f262be91d70e03344baaa1cf5d71dde662a12453262604ee44a0d5e9d29c347f9752424e68c1c4419b2969f9a7294ffea02e5c0'
    checksumType  = 'sha512'
}

$installerFile = (Join-Path ${ENV:TEMP} "$env:chocolateyPackageName.exe")
$workDirectory = New-Item (Join-Path ${ENV:TEMP} "$env:chocolateyPackageName") -ItemType Directory -Force
$outputFolder = New-Item (Join-Path $env:chocolateyPackageFolder "dist") -ItemType Directory -Force

Get-ChocolateyWebFile @packageArgs -file $installerFile
# Use 7zip.portable to extract the files, the one that comes with Chocolatey does not extract correctly
$sevenZip = (Join-Path $env:ChocolateyInstall "lib/7zip.portable/tools/7z.exe") + " -o$outputFolder x $installerFile"
iex $sevenZip 

# Remove the uninstaller and plugin folders along with temp folder
Remove-Item (Join-Path $outputFolder 'uninst.exe')
Remove-Item (Join-Path $outputFolder '$PLUGINSDIR') -Recurse
Remove-Item $workDirectory -Recurse -Force
Remove-Item $installerFile -Force
