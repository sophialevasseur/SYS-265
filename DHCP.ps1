# Retrieve the Domain User
$NDU = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Retrieve the Net-adapter config/ filter for ipv4
$netConfigs = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
$netConfig = $netConfigs | Where-Object { $_.IPAddress -match '\.' } | Select-Object -First 1

# Get the ipv4
$ipv4Address = ($netConfig.IPAddress | Where-Object { $_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$' }) -join ', '

# Get the server ip for dhcp
$dhcpServer = $netConfig.DHCPServer

# Get the default gateway ip
$gateway = ($netConfig.DefaultIPGateway | Where-Object { $_ -match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$' }) -join ', '

# Get teh dns server ip
$dnsServers = $netConfig.DNSServerSearchOrder -join ', '

# build the table output
$result = [PSCustomObject]@{
    'Named Domain User' = $NDU
    'IPv4 Address'      = $ipv4address
    'DHCP Server IP'    = $dhcpServer
    'Default Gateway'   = $gateway
    'DNS Servers'       = $dnsServers
}

# show as a organized table
$result | Format-Table -AutoSize
