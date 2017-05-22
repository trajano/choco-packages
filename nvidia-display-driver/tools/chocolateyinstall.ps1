$installerFile = (Join-Path ${ENV:TEMP} "nvidiadriver.exe")
$workDirectory = New-Item (Join-Path ${ENV:TEMP} "nvidiadriver") -ItemType Directory -Force

$packageArgs = @{
    packageName   = $env:chocolateyPackageName
    url = "http://us.download.nvidia.com/Windows/$env:chocolateyPackageVersion/$env:chocolateyPackageVersion-desktop-win10-32bit-international-whql.exe"
    checksum      = ''
    checksumType  = 'sha512'

    url64bit = "http://us.download.nvidia.com/Windows/$env:chocolateyPackageVersion/$env:chocolateyPackageVersion-desktop-win10-64bit-international-whql.exe"
    checksum64    = ''
    checksumType64= 'sha512'

    silentArgs = "-s -noreboot -clean"
}

# override to use the non-Windows 10 versions
If ( [System.Environment]::OSVersion.Version.Major -ne '10' ) {
	$packageArgs.url   = "http://us.download.nvidia.com/Windows/$env:chocolateyPackageVersion/$env:chocolateyPackageVersion-desktop-win8-win7-32bit-international-whql.exe"
	$packageArgs.url64 = "http://us.download.nvidia.com/Windows/$env:chocolateyPackageVersion/$env:chocolateyPackageVersion-desktop-win8-win7-64bit-international-whql.exe"
	$packageArgs.checksum   = ''
	$packageArgs.checksum64 = ''
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
