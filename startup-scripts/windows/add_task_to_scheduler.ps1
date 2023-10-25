# this script does not work :(

$ScriptFile = "C:\change_hostname.ps1"

$TaskName = "Zmiana hostname przy starcie"
$TaskDescription = "Uruchamia skrypt PowerShell przy każdym uruchomieniu komputera."

# Admin user info
$AdminUser = "Administrator"
$AdminPassword = ConvertTo-SecureString -String "Catalogic@123" -AsPlainText -Force

# Create new task in scheduler
$Trigger = New-ScheduledTaskTrigger -AtStartup
$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-ExecutionPolicy Bypass -File '$ScriptFile'"
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName $TaskName -Description $TaskDescription -User $AdminUser -Password $AdminPassword

Write-Host "Created task: $TaskName"
