This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

GS  
May 2026


## Background info: general printer and driver notes

Any "driverless" driver that Ubuntu automatically installs via the "Add Printer..." setting option shown in the screenshot below is going to print _really really slow__ on this printer. The reason is that "driverless" drivers send over the full file, ex: as a PDF, to the printer, and then the printer has to download, process, and print the file itself. This printer has a very small RAM and slow processor, making this burden take about **2 minutes per page**. It works, but is SLOW.

Using the Brother driver, on the other hand, converts the file to a printer-friendly format on the computer, and then sends it to the printer, which can print it much faster. With the Brother driver, it takes about **10 seconds per page**. So it's worth installing the Brother driver for this printer if you want to print at a reasonable speed.

In my Ubuntu Settings -> Printers menu, you can see 3 installations here. The first two I added by clicking the "Add Printer..." button right there. These are the _super slow_ 2 minutes-per-page "driverless" drivers. The third one, `MFC9340CDW`, is the genuine Brother driver I installed using my instructions below. It prints _much faster_ at about 10 seconds per page.

<img width="997" height="829" alt="Image" src="https://github.com/user-attachments/assets/9ae4e877-aca6-4360-86c3-f640de209bde" />

When installing the Brother driver, I like to use the `dnssd` connection option / device URI, which is what is automatically selected if you type `a` for "Auto" during the installation process, as shown below. 


## Brother MFC-9340CDW Installation instructions

_Tested on Linux Ubuntu 22.04._

Drivers: https://support.brother.com/g/b/downloadtop.aspx?c=us&lang=en&prod=mfc9340cdw_all -> choose Linux, then "Linux (deb)" -> OK -> that brings you here: https://support.brother.com/g/b/downloadlist.aspx?c=us&lang=en&prod=mfc9340cdw_all&os=128

Download the "Driver Install Tool". Direct page: https://support.brother.com/g/b/downloadend.aspx?c=us&lang=en&prod=mfc9340cdw_all&os=128&dlid=dlf006893_000&flang=4&type3=625

#### Terminal commands

```bash
# Update this based on the latest one available at the links above. 
DRIVER="linux-brprinter-installer-2.2.6-0"

# download the "Driver Install Tool"
wget "https://download.brother.com/welcome/dlf006893/$DRIVER.gz"

# Unzip it into a directory named the same as it; ex: "linux-brprinter-installer-2.2.6-0"
mkdir -p "$DRIVER"
gunzip "$DRIVER.gz" -c > "$DRIVER/$DRIVER"

# Run the installer
cd "$DRIVER"
sudo bash "$DRIVER" MFC-9340CDW
# Now follow the install instructions just below: 
```

#### Installer steps after running `sudo bash $DRIVER MFC-9340CDW`

It says: 
```
You are going to install following packages.
   mfc9340cdwlpr-1.1.2-1.i386.deb
   mfc9340cdwcupswrapper-1.1.4-0.i386.deb
   brscan4-0.4.11-1.amd64.deb
   brscan-skey-0.3.4-0.amd64.deb
OK? [y/N] ->y
```
Choose: `y` to install, `y` for Brother license agreement, `y` for GPL license agreement, `y` to specify the device URI (for a network printer), `a` for auto: `16 (A): Auto. (dnssd://Brother%20MFC-9340CDW._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-30055c38bb7d)`, `y` to test print. 

That installed the first two things above: 
```
mfc9340cdwlpr-1.1.2-1.i386.deb
mfc9340cdwcupswrapper-1.1.4-0.i386.deb
```

The completion of the first two things above results in the printer driver being installed and showing up in your printer settings in Ubuntu, as shown here: 

<img width="997" height="829" alt="Image" src="https://github.com/user-attachments/assets/9ae4e877-aca6-4360-86c3-f640de209bde" />

It then says: 
```
You are going to install following packages.
   brscan4-0.4.11-1.amd64.deb
dpkg -i --force-all brscan4-0.4.11-1.amd64.deb
```
Press `y` to agree to the Brother license agreement. 

It then says: 
```
You are going to install following packages.
   brscan-skey-0.3.4-0.amd64.deb
dpkg -i --force-all brscan-skey-0.3.4-0.amd64.deb
...
 enter IP address ->
```
Go to the printer and get the IP address from the network menu. Enter it here. Ex: `192.168.1.66`. 

Screenshot of this IP from the printers network settings menus: 

<img width="1897" height="1311" alt="Image" src="https://github.com/user-attachments/assets/e431c766-f534-4599-b834-2a66e0c24385" />

Driver installation is now done. 

**Set the new printer as default:**

Press the <kbd>Windows</kbd> key -> type "Printers" -> click it from the settings menu that pops up -> click the gear icon next to the new `MFC9340CDW` printer that shows up -> check the box for "User Printer by Default." 

Done!
