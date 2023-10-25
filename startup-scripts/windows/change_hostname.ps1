$NewHostnamePrefix = "PREFIX"
$HostnameConfiguredFile = "C:\hostname_is_configured.txt"
$HostnameAlreadyConfigured = Test-Path -Path "$HostnameConfiguredFile" -PathType Leaf

# Checking if setting the hostname is needed
if (-not($HostnameAlreadyConfigured))
{
    # Set allowed ASCII character codes to Uppercase letters (65..90),
    $charcodes = 65..90

    # Convert allowed character codes to characters
    $allowedChars = $charcodes | ForEach-Object { [char][byte]$_ }
    $LengthOfName = 15

    # Generate computer name
    $randomChars = ($allowedChars | Get-Random -Count ($LengthOfName - $NewHostnamePrefix.Length)) -join ""
    $DesiredHostname = $NewHostnamePrefix + $randomChars

    # Changing the hostname
    Write-Output "Changing hostname..."
    Rename-Computer -NewName "$DesiredHostname" -Force

    # Marking that configuration was completed
    Out-File -FilePath "$HostnameConfiguredFile" -InputObject "Delete this file to generate new hostname at system startup."

    # Reboot
    Write-Output "The hostname was changed."
    Write-Output "Rebooting."
    Restart-Computer -Force
}
else
{
    # Setting the hostname is not needed
    Write-Output "No need to set the hostname."
}
