This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Here are a few notes and references about the `/etc/rc.local` Linux startup script file

The `/etc/rc.local` file is used to automatically run certain scripts or cmds at boot, as the root (sudo) user. Whatever you put inside it will automatically be run each boot as root. It works on Ubuntu. I'm not sure about other Linux distributions, but I imagine it applies to pretty much any Linux OS.


# See

1. [Stack Overflow: How to run a shell script at startup](https://stackoverflow.com/q/12973777/4561887). The 3 main approaches presented are:
    1. [`crontab` with `@reboot`](https://stackoverflow.com/a/29247942/4561887) 
    1. The [`/etc/init.d/` directory](https://stackoverflow.com/a/12973826/4561887)
    1. The [`/etc/rc.local` file](https://stackoverflow.com/a/12973820/4561887)
1. [my answer] See my comments underneath my answer: [Unix & Linux: How can I create a virtual ethernet interface on a machine without a physical adapter?](https://unix.stackexchange.com/a/593142/114401)
1. [my answer] [Super User: How do I use magic sysreq keys on a Mac?](https://superuser.com/a/1192317/425838). Quote from my answer, with `/etc/rc.local` file setup and creation info:

    1. > **_Note_**: on recent Ubuntu versions, `/etc/rc.local` does not exist by default, but as explained in [this answer](https://askubuntu.com/a/919598) and [this answer][5], it is used if it 1) exists, 2) is executable by at least the root user, and 3) contains a [hashbang][6] at the top, such as `#!/bin/sh -e`. Be sure it is owned by root and executable (`sudo gedit /etc/rc.local` OR `gedit /etc/rc.local` followed by `sudo chown root:root rc.local`; then `sudo chmod u+x /etc/rc.local`).

1. [my answer] [Raspberry Pi: Can't get a CIFS network drive to mount on boot](https://raspberrypi.stackexchange.com/a/63690/49091)



  [5]: https://stackoverflow.com/a/53362812/4561887
  [6]: https://en.wikipedia.org/wiki/Shebang_(Unix)
