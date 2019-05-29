Start-Transcript -Path $(Join-Path $env:temp "DriveMapping.log")

Test-NetConnection -ComputerName dadintunestorage2.file.core.windows.net -Port 445
# Save the password so the drive will persist on reboot
Invoke-Expression -Command "cmdkey /add:dadintunestorage2.file.core.windows.net /user:Azure\dadintunestorage2 /pass:J4AH8DVKFijm5EjuMnvIEpjuMhtoBqLq6KgDbT8NeNJgmH2gti+ZSxaK7X5+3O+QYmHNRzE3pyHATMboyNVvKg=="
$driveMappingConfig=@()


######################################################################
#                section script configuration                        #
######################################################################

<#
   Add your internal Active Directory Domain name and custom network drives below
#>

$dnsDomainName= "AD500.net"


$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "E"
    UNCPath= "\\dadintunestorage2.file.core.windows.net\test"
    Description="Pool"
}


#$driveMappingConfig+=  [PSCUSTOMOBJECT]@{
 #   DriveLetter = "T"
  #  UNCPath= "\\vfs01.tech.nicolonsky.ch\software"
   # Description="Software"
#}

#$driveMappingConfig+=  [PSCUSTOMOBJECT]@{
 #   DriveLetter = "V"
  #  UNCPath= "\\vfs01.tech.nicolonsky.ch\archiv"
   # Description="Archiv"
#}

######################################################################
#               end section script configuration                     #
######################################################################

$connected=$false
$retries=0
$maxRetries=3

#Map drives
    $driveMappingConfig.GetEnumerator() | ForEach-Object {

        Write-Output "Mapping network drive $($PSItem.UNCPath)"

        New-PSDrive -PSProvider FileSystem -Name $PSItem.DriveLetter -Root $PSItem.UNCPath -Description $PSItem.Description -Persist -Scope global

        (New-Object -ComObject Shell.Application).NameSpace("$($PSItem.DriveLEtter):").Self.Name=$PSItem.Description
}

Stop-Transcript