This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

## Here are a few notes and references about the `/etc/rc.local` Linux startup script file:

This file is used to automatically run certain scripts or cmds at boot, as the root (sudo) user. Whatever you put inside it will automatically be run each boot as root. It works on Ubuntu. I'm not sure about other Linux distributions, but I imagine it applies to pretty much any Linux OS.

1. [my answer] See my comments underneath this answer: https://unix.stackexchange.com/questions/152331/how-can-i-create-a-virtual-ethernet-interface-on-a-machine-without-a-physical-ad/593142#593142
1. [my answer] https://superuser.com/questions/652385/how-do-i-use-magic-sysreq-keys-on-a-mac/1192317#1192317
    1. > **_Note_**: on recent Ubuntu versions, `/etc/rc.local` does not exist by default, but as explained in [this answer](https://askubuntu.com/a/919598) and [this answer][5], it is used if it 1) exists, 2) is executable by at least the root user, and 3) contains a [hashbang][6] at the top, such as `#!/bin/sh -e`. Be sure it is owned by root and executable (`sudo gedit /etc/rc.local` OR `gedit /etc/rc.local` followed by `sudo chown root:root rc.local`; then `sudo chmod u+x /etc/rc.local`).
1. [my answer] https://raspberrypi.stackexchange.com/questions/34444/cant-get-a-cifs-network-drive-to-mount-on-boot/63690#63690


  [5]: https://stackoverflow.com/a/53362812/4561887
  [6]: https://en.wikipedia.org/wiki/Shebang_(Unix)
