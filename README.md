# WSL-HyperV-fix
this script will allow WSL instances to connect to Hyper-V instances by enables forwarding between the virtual interfaces ( wsl / default switch)

# Potential-Problems
1 - if there are more than 2 virtual switches the forwarding wont work
2 - if the Hyper-V vm is set to save when the host shuts down the ip address to ping will be wrong

# Potential-Fix
1 - the actual problem of more than 2 switchs is the APIPA address of the 3rd switch.
  if you can get a 172 address on the third Vswitch it should work
  but not exactly sure if Set-NetIPInterface -Forwarding can take more than 2 interfaces
2 - restart the Hyper-V vm
