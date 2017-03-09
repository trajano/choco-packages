$installerFile = (Join-Path ${ENV:TEMP} "nvidiadriver.exe")
$workDirectory = New-Item (Join-Path ${ENV:TEMP} "nvidiadriver") -ItemType Directory -Force

$packageArgs = @{
    packageName   = $env:chocolateyPackageName
    url = "http://us.download.nvidia.com/Windows/$env:chocolateyPackageVersion/$env:chocolateyPackageVersion-desktop-win10-32bit-international-whql.exe"
    checksum      = '34f6edbfca3cbe70dc83589bfae339437658b2b8c291a9fc278aee0c7cabf6d495ebfb64dff8da3dc6966409ce2857a911c6a39d489c3c6b9fb5597075e04361'
    checksumType  = 'sha512'

    url64bit = "http://us.download.nvidia.com/Windows/$env:chocolateyPackageVersion/$env:chocolateyPackageVersion-desktop-win10-64bit-international-whql.exe"
    checksum64    = '753e7023b6ea7dd451cc1ac639d838f6f137a4153e88d6051d8217d69be631f007e90c3a672e795e31abf8a930927a7376eeca7da5852c4cf8de522f51a0fc73'
    checksumType64= 'sha512'

    silentArgs = "-s -noreboot -clean"
}

# override to use the non-Windows 10 versions
If ( [System.Environment]::OSVersion.Version.Major -ne '10' ) {
	$packageArgs.url   = "http://us.download.nvidia.com/Windows/$env:chocolateyPackageVersion/$env:chocolateyPackageVersion-desktop-win8-win7-32bit-international-whql.exe"
	$packageArgs.url64 = "http://us.download.nvidia.com/Windows/$env:chocolateyPackageVersion/$env:chocolateyPackageVersion-desktop-win8-win7-64bit-international-whql.exe"
	$packageArgs.checksum   = '2f81b0778d65436708369c3283ca37fa72825eb12c512c22e92362efbf47fa0a17b4d7c86bba289b12007c5c781b33e8a9d1ae891c62c8b2a7913272ffcdd46f'
	$packageArgs.checksum64 = 'd1883e733fa15ba43b76475cb9829bc8fb5edc2fb7efed49e24b3fc206b474f209f0a6b49f4e22a197c3b3c1f0e3f959b2649b394fdf0d6d4e68dafd0d4a8f00'
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
