
Gabriel Staples

This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


==========================================================================================  
# Windows networking:
==========================================================================================  

## Adding a static ARP entry to the ARP table in Windows

```bash
# [General form] Add a static ARP entry to the ARP table (mapping an IP address to a MAC 
# address) in Windows:
# - Run in Git Bash or Cmd Prompt as admin!
netsh interface ipv4 add neighbors "<Windows Interface Name>" "192.168.10.20" "<MAC ADDRESS>"

# Get the "Windows Interface Name" from the "Name" column in the output of this:
netsh interface ipv4 show interfaces

# Add a static ARP entry to the ARP table (mapping an IP address to a MAC address) in Windows: 
# Example: 
# Run in Git Bash as admin!
#                               Interface Name   IP        Physical MAC Address
#                                    |           |                 |
netsh interface ipv4 add neighbors "Wi-Fi" "192.168.10.20" "01-23-45-67-89-AB"

# You'll now see a new entry in the `arp -a` table for the IP address connected to this interface!
arp -a 
```

New entry now!:
```bash
gabriel@MyComputer MINGW64 ~/GS/dev/my_repo$ arp -a

Interface: 192.168.10.5 --- 0x2
  Internet Address      Physical Address      Type
  192.255.255.255       ff-ff-ff-ff-ff-ff     static
  192.168.10.20         01-23-45-67-89-AB     static  # <=== JUST ADDED BY US ABOVE!
```

