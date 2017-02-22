$installerFile = (Join-Path ${ENV:TEMP} "nvidiadriver.exe")
$workDirectory = New-Item (Join-Path ${ENV:TEMP} "nvidiadriver") -ItemType Directory -Force

$packageArgs = @{
    packageName   = $env:chocolateyPackageName
    url = "http://us.download.nvidia.com/Windows/$env:chocolateyPackageVersion/$env:chocolateyPackageVersion-desktop-win10-32bit-international-whql.exe"
    checksum      = 'ea988083e3b43cbcbcef54ad29b6d8d2c4f625460de41292c48661354837e6f0'
    checksumType  = 'sha256'

    url64bit = "http://us.download.nvidia.com/Windows/$env:chocolateyPackageVersion/$env:chocolateyPackageVersion-desktop-win10-64bit-international-whql.exe"
    checksum64    = 'ddf2e726eefd1e5cdaba31ec023c075df282685377652c1bdd343be1b1792b9cc393f0eed50b0ebc31b37bd651470f86a908de559c3969ea7472e5b0045ac12c'
    checksumType64= 'sha512'

    silentArgs = "-s -noreboot -clean" 
}

# TODO make this part driven by parameters to enable or disable components should people want GEForce Experience or 3DVision
$deselectedPatterns = @(
    "NV3DVision*", 
    "GFExperience*",
    "Display.NView", 
    "Display.Update")

Get-ChocolateyWebFile @packageArgs -FileFullPath $installerFile
Get-ChocolateyUnzip $installerFile $workDirectory

# Update the setup.cfg
$setupCfgFile = Join-Path $workDirectory "setup.cfg"
[xml] $setupCfgDoc = (Get-Content $setupCfgFile)

# Explicitly deselect packages
foreach ($pattern in $deselectedPatterns) {
    $child = $setupCfgDoc.CreateElement("deselect")
    $childAttribute = $setupCfgDoc.CreateAttribute("name")
    $childAttribute.Value = "**\$pattern\**\*"
    [void] $child.Attributes.Append($childAttribute)
    [void] $setupCfgDoc.setup.install.search.AppendChild($child)
}
($setupCfgDoc.setup.install.'sub-package' | where { $_.name -eq 'Display.GFExperience' }).disposition = 'demand'
($setupCfgDoc.setup.install.'sub-package' | where { $_.name -eq 'Display.Update' }).disposition = 'demand'

[void] $setupCfgDoc.Save($setupCfgFile)

Install-ChocolateyInstallPackage @packageArgs -File (Join-Path $workDirectory "setup.exe")

Remove-Item $workDirectory -Recurse -Force
Remove-Item $installerFile -Force
