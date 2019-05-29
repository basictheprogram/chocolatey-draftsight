$ErrorActionPreference = 'Stop'; # stop on all errors

$packageName = 'DraftSight'
$url64       = 'N:\gold-images\Solidworks\DraftSight\DraftSight64_2018_SP3.exe'        # Change to your URI
$checkSum64  = 'e17837ebd6a7c062d2502a397308a7a34515462834b23fbc134e686d4b3de195'

# if an older version of DraftSight has been run, the API service will prevent upgrading it.
if (Get-Service -DisplayName "Draftsight API Service*" | Where {$_.status -eq 'running'}) {
   Stop-Service -DisplayName "Draftsight API Service*" -Force -PassThru
}

$WorkSpace = Join-Path $env:TEMP "$packageName.$env:chocolateyPackageVersion"

$UnzipArgs = @{
   PackageName  = $packageName
   FileFullPath = $url64 
   Destination  = $WorkSpace
}

Get-ChocolateyUnzip @UnzipArgs

$InstallArgs = @{
   PackageName    = $packageName
   File           = Join-Path $WorkSpace "$packageName.msi"
   fileType       = 'msi'
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @InstallArgs
