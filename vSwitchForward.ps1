#Powershell WSL+Hyper-V script V1

# Checks for admin priveledges (straight from stack overflow)
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) 
{
 Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-File `"$($MyInvocation.MyCommand.Path)`"  `"$($MyInvocation.MyCommand.UnboundArguments)`""
 Exit }

# Gets the virtual interfaces WSL and Default Switch
$Host_WSLaddr = Get-NetIPAddress | where {$_.InterfaceAlias -match 'WSL' -and $_.AddressFamily -eq 'IPv4'}
$Host_Vaddr = Get-NetIPAddress | where {$_.InterfaceAlias -match 'Default' -and $_.AddressFamily -eq 'IPv4'}

# Enable forwarding between interfaces
Get-NetIPAddress | where {$_.InterfaceAlias -match 'vEthernet' -and $_.AddressFamily -eq 'IPv4'} |Set-NetIPInterface -Forwarding Enabled -Verbose

echo "Forwarding Enabled on interfaces:" $Host_Vaddr.InterfaceAlias $Host_WSLaddr.InterfaceAlias 

# ip route command to tell the vm in wsl where to send for hyper-v
$message1 = 'sudo ip route add ' + $Host_Vaddr.IPAddress + ' via ' + $Host_WSLaddr.IPAddress + ' dev eth0'

echo "Put this into a WSL terminal:"
echo $message1

# Gets the ip address of virtual machines in Hyper-V
$VMwIPaddr = Get-VM | Get-VMNetworkAdapter | where {$_.IPAddresses -ne $null}

$message2 =  "To test ping " + $VMwIPaddr.IPAddresses + " from the WSL terminal"
$message3 = "To test turn on a Hyper-V VM and try pinging it."

if ($VMwIPaddr.IPAddresses -ne $null) 
{
echo $message2
} else {
echo $message3
}

Read-Host -Prompt "Press any key to continue..."