$os = "windows"
$targetIP = "192.168.129.209"
$targetPort = 7321
$gmaServiceName = "CatalogicGuardModeAgent"

try {
    # Get GMA service
    $gmaService = Get-Service -Name $gmaServiceName -ErrorAction Stop

    # Get gma service status
    $gmaStatus = $gmaService.Status
} catch {
    # Set fallback service status
    $gmaStatus = "Absent"
}

# Get hostname
$hostName = [System.Net.Dns]::GetHostName()

# Create UDP client
$udpClient = New-Object System.Net.Sockets.UdpClient

# Data -> bytes
$data = [System.Text.Encoding]::ASCII.GetBytes("$hostName $os $gmaStatus")

# Send through UDP
$udpClient.Send($data, $data.Length, $targetIP, $targetPort)

# Close client UDP
$udpClient.Close()