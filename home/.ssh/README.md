This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Table of Contents
<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC -->

1. [1. `ssh` key generation, setup, and configuration notes:](#1-ssh-key-generation-setup-and-configuration-notes)
    1. [References:](#references)
    1. [Example of files you may have in your `~/.ssh` dir](#example-of-files-you-may-have-in-your-~ssh-dir)
    1. [Public/Private ssh generation and copying to your server's `~/.ssh/authorized_keys` file](#publicprivate-ssh-generation-and-copying-to-your-servers-~sshauthorized_keys-file)
    1. [SSH example aliases](#ssh-example-aliases)
1. [2. How to source a custom .bashrc file whenever you ssh into a remote Linux device](#2-how-to-source-a-custom-bashrc-file-whenever-you-ssh-into-a-remote-linux-device)
    1. [References:](#references-1)
    1. [1. When your target Linux device _does_ have the `bash` shell](#1-when-your-target-linux-device-does-have-the-bash-shell)
        1. [Command:](#command)
        1. [\[1/2: USE THIS WHEN YOUR TARGET DEVICE HAS `bash`\] Optional \(but recommended\) Alias:](#12-use-this-when-your-target-device-has-bash-optional-but-recommended-alias)
        1. [Apply Ubuntu's settings for ALL users who log into the `root` username on the target device](#apply-ubuntus-settings-for-all-users-who-log-into-the-root-username-on-the-target-device)
    1. [2. When your target Linux device does NOT have the `bash` shell, and you must use the `busybox` `ash` \(preferred\) or `sh` shell instead](#2-when-your-target-linux-device-does-not-have-the-bash-shell-and-you-must-use-the-busybox-ash-preferred-or-sh-shell-instead)
        1. [Here are some basic, dumbed-down `~/.profile` and `~/.bashrc` configuration files you can use for your target embedded Linux device if you like:](#here-are-some-basic-dumbed-down-~profile-and-~bashrc-configuration-files-you-can-use-for-your-target-embedded-linux-device-if-you-like)
        1. [\[2/2: USE THIS WHEN YOUR TARGET DEVICE DOES NOT HAVE `bash`, SO YOU MUST USE `ash`\] Now, use the following alias to ssh into the target device and auto-configure your `ash` shell environment at the same time](#22-use-this-when-your-target-device-does-not-have-bash-so-you-must-use-ash-now-use-the-following-alias-to-ssh-into-the-target-device-and-auto-configure-your-ash-shell-environment-at-the-same-time)
1. [3. Dropbear setup and notes to remotely decrypt a LUKS-encrypted hard drive](#3-dropbear-setup-and-notes-to-remotely-decrypt-a-luks-encrypted-hard-drive)
    1. [References:](#references-2)
    1. [1. Background and learning](#1-background-and-learning)
    1. [2. The actual steps to set up Dropbear](#2-the-actual-steps-to-set-up-dropbear)
    1. [3. Test it: reboot, ssh in to dropbear, decrypt your hard drive, and ssh in like normal](#3-test-it-reboot-ssh-in-to-dropbear-decrypt-your-hard-drive-and-ssh-in-like-normal)

<!-- /MarkdownTOC -->
</details>


<a id="1-ssh-key-generation-setup-and-configuration-notes"></a>
# 1. `ssh` key generation, setup, and configuration notes:

<a id="references"></a>
## References:
1. [EXCELLENT!] Great background information on what ssh keys are and how they work, as well as how to use and create them:
https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server
1. [EXCELLENT!] Great, generic ssh key-generation steps and instructions, as well as how to add your public key to GitHub so you can access your repos remotely from the git command-line: 
https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
1. How to run commands over ssh: https://www.cyberciti.biz/faq/unix-linux-execute-command-using-ssh/

<a id="example-of-files-you-may-have-in-your-~ssh-dir"></a>
## Example of files you may have in your `~/.ssh` dir

```bash
~/.ssh$ tree
.
├── authorized_keys
├── config
├── id_ed25519
├── id_ed25519.pub
├── id_rsa
├── id_rsa.pub
├── id_rsa_dropbear
├── id_rsa_dropbear.pub
└── known_hosts
```

<a id="publicprivate-ssh-generation-and-copying-to-your-servers-~sshauthorized_keys-file"></a>
## Public/Private ssh generation and copying to your server's `~/.ssh/authorized_keys` file

Here is how to generate a new ssh public/private key combo and copy your public key to your server's `~/.ssh/authorized_keys` file so you can have a password-less login into that server:

```bash
# 1. Generate a key
# See: https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# When generating a key below, it is recommended that you DO add a password to encrypt and protect 
# the key file when the keygen utility asks you to do so.

# A. (BEST) Use the ed25519 type because it is the most secure as of the year 2021 (prior to ed25519
# being created, `rsa` was the most secure)
ssh-keygen -t ed25519 -C "your_email@example.com"
# B. (OK if the ed25519 type is not supported) From the GitHub link above: "Note: If you are using a
# legacy system [GS note: or lightweight implementation, such as the Dropbear ssh server] that
# doesn't support the Ed25519 algorithm, use:"
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"


# 2. Add your ssh key to the `ssh-agent`
# See link above

# Ensure the ssh-agent is running
eval "$(ssh-agent -s)"

# Add your private key to it; update the path to your private key below, as required, based on what
# path you interactively selected above when generating the key
ssh-add ~/.ssh/id_ed25519


# 3. Copy your **public** key to your server you'd like to log into. 
# NB: **NEVER** share your private key. That lets other people act as you. Your public key, however,
# can be safely shared publicly.
#
# vvvvvvvvv
# Basically, you just need to copy the contents of your public key file ("~/.ssh/id_ed25519.pub" in
# the example above) into your server's "~/.ssh/authorized_keys" file is all. Below are a couple
# ways to do so.
# ^^^^^^^^^

# Option A: if you have password-based ssh login enabled on your server, you can copy your public
# key remotely to it like this:
# See: https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server
# Update the path to the public key 'i'dentity file as required. 
# >> NB: I need to test this: am I doing this right, or is the `-i` option for specifying the ssh 
# connection itself which copies the .pub key? <<
# [NEED TO TEST THIS]
ssh-copy-id -i ~/.ssh/id_ed25519.pub username@remote_host
# OR (same thing, but done manually) [NEED TO TEST THIS]:
scp ~/.ssh/id_ed25519.pub username@remote_host:~/.ssh && \
    ssh username@remote_host 'cat ~/.ssh/id_ed25519.pub >> ~/.ssh/authorized_keys'

# Option B: if you do NOT have password-based ssh login enabled on your server, but you can
# NoMachine into it, then you can manually copy/paste the contents of your "~/.ssh/id_ed25519.pub"
# file, via the NoMachine GUI login, into your server's "~/.ssh/authorized_keys" file. You can also
# email the **public key** "~/.ssh/id_ed25519.pub" file to your remote server and graphically (via a
# GUI text editor) copy/paste it into your `~/.ssh/authorized_keys` file from your email, or
# whatever. 
```

<a id="ssh-example-aliases"></a>
## SSH example aliases

You can set up **custom ssh aliases** in your ssh config file like this:

Add to your `~/.ssh.config` file:
```bash
# Note: see `man ssh_config` for details
Host my-ssh-alias
    HostName MY_HOSTNAME_OR_IP_ADDRESS
    User root 
    Port 22
    IdentityFile ~/.ssh/id_rsa
```

Change `MY_HOSTNAME_OR_IP_ADDRESS` to whatever it should be; ex: `192.168.0.2`.

Now call `ssh my-ssh-alias` to use this alias! That alias is the equivalent of calling `ssh root@192.168.0.2 -p 22 -i ~/.ssh/id_rsa` from the command-line. Alternatively (this is what I usually do instead), instead of using an _ssh config file alias_, just add the following _bash alias_ to your `~/.bashrc`, `~/.bash_aliases`, or (recommended) `~/.bash_aliases_private` file instead. This is what I usually do, as I don't see any advantage whatsoever (yet, at least; _UPDATE:_ one advantage is you can type `ssh` and press Tab Tab (Tab twice) to see an autocompleted list of ssh aliases you can ssh into!) to using _ssh config file aliases_ over normal _bashrc aliases_, and I like keeping all my aliases together so it's less to manage:
```bash
alias my_ssh_alias="ssh root@192.168.0.2 -p 22 -i ~/.ssh/id_rsa"
```

Assuming you use both _ssh config file aliases_ **and** normal _bash aliases_, the following three commands are now equivalent:
```bash
# 3 equivalent commands!

# 1. ssh config file alias
ssh my-ssh-alias
# 2. bash alias
my_ssh_alias
# 3. full ssh command manually typed in
ssh root@192.168.0.2 -p 22 -i ~/.ssh/id_rsa
```


<a id="2-how-to-source-a-custom-bashrc-file-whenever-you-ssh-into-a-remote-linux-device"></a>
# 2. How to source a custom .bashrc file whenever you ssh into a remote Linux device

This is very useful, for example, when ssh-ing into an embedded Linux device or a shared device where you all ssh into the same username--ex: `root`, but you do NOT want to share a startup file nor modify it for others. Rather, you want to have your own custom aliases and environment and coloring and things. 


<a id="references-1"></a>
## References:
1. How to use `sshpass -p` and `sshpass -f`: https://stackoverflow.com/questions/50096/how-to-pass-password-to-scp/13955428#13955428
1. How to use `sshpass -f` _as though it was_ `sshpass -p`, but in a more-secure way, using _process substitution_ (`<()`): https://stackoverflow.com/questions/24454037/pass-a-password-to-ssh-in-pure-bash/24455773#24455773
1. [my question on _process substitution_] How to load files in `sh` from file descriptor 3 (`/dev/fd/3`), since _process substitution_ works in `bash` but NOT in `sh` shells, and since `/dev/fd/0` is already taken up as **stdin**, `/dev/fd/1` is **stdout**, and `/dev/fd/2` is **stderr**: https://unix.stackexchange.com/questions/676676/sh-syntax-error-unexpected-when-attempting-process-substitution-on-an-e/676681#676681
1. How to restore Ubuntu's default `~/.bashrc` file from `/etc/skel/.bashrc`: https://askubuntu.com/questions/404424/how-do-i-restore-bashrc-to-its-default/404428#404428
1. [answer to my question] How to do it when your target embedded Linux device has only the `busybox` `ash` and `sh` shells, NOT the regular `bash` shell: https://unix.stackexchange.com/questions/677145/ssh-start-a-specific-shell-ash-and-source-your-environment-on-the-remote-mac/677149#677149
1. Read about how `ash` uses this `ENV` environment variable in the `ash` documentation here: https://linux.die.net/man/1/ash


<a id="1-when-your-target-linux-device-does-have-the-bash-shell"></a>
## 1. When your target Linux device _does_ have the `bash` shell

<a id="command"></a>
### Command:
```bash
# 1. Store your ssh password into a `~/pw` file.
# - NB: this is useful for embedded Linux devices where you may have a read-only filesystem in the
#   home dir and cannot modify the target's `~/.ssh/authorized_keys` file as described above. But,
#   storing a password into a raw file like this is otherwise NOT normally recommended.
echo "my_password" > ~/pw

# 2. Copy over your default Ubuntu `/etc/skel/.bashrc` file to the target device at 
# `/tmp/.bashrc`, then ssh into the target device and load the `bash` shell (in case it otherwise
# has a default shell of `sh` or something) with the startup file you just copied over.
# - Note: the `-t` option passed to ssh forces the terminal to be a human-interactive "tty" style
#   terminal, so that it won't just run the given command and close. Rather, it stays open and
#   remains ready for interaction from you, the user.
sshpass -f ~/pw scp /etc/skel/.bashrc root@192.168.0.2:/tmp \
&& sshpass -f ~/pw ssh -t root@192.168.0.2 'bash --rcfile /tmp/.bashrc'
```

<a id="12-use-this-when-your-target-device-has-bash-optional-but-recommended-alias"></a>
### [1/2: USE THIS WHEN YOUR TARGET DEVICE HAS `bash`] Optional (but recommended) Alias:
Now, you can optionally make the above ssh command an alias like this. Notice that I've also added the `-o 'ServerAliveInterval 60'` option to help keep the connection open (similar to [what I recommend in my answer here](https://askubuntu.com/a/942820/327339)).
```bash
# Manually add something like this to your ~/.bash_aliases (recommended) or ~/.bashrc file on the PC
# you are ssh-ing FROM:
alias gs_ssh="sshpass -f ~/pw scp /etc/skel/.bashrc root@192.168.0.2:/tmp \
&& sshpass -f ~/pw ssh -t -o 'ServerAliveInterval 60' root@192.168.0.2 'bash --rcfile /tmp/.bashrc'"

# Re-source your ~/.bashrc file when done adding the alias above for the first time. Note that if on
# Ubuntu this also automatically re-sources your ~/.bash_aliases file if you have one!
. ~/.bashrc
```

<a id="apply-ubuntus-settings-for-all-users-who-log-into-the-root-username-on-the-target-device"></a>
### Apply Ubuntu's settings for ALL users who log into the `root` username on the target device

If your target filesystem's home directory is NOT read-only, you can affect the environment for ALL users like this:

```bash
# Secure-copy over Ubuntu's default .profile AND .bashrc files to the target's home dir
sshpass -f ~/pw scp /etc/skel/.profile /etc/skel/.bashrc root@192.168.0.2:~

# Now ssh in
# A. using sshpass which automatically types the password for you
sshpass -f ~/pw ssh -t root@192.168.0.2 'bash --login'
# OR B. using normal ssh
ssh -t root@192.168.0.2 'bash --login'
```


<a id="2-when-your-target-linux-device-does-not-have-the-bash-shell-and-you-must-use-the-busybox-ash-preferred-or-sh-shell-instead"></a>
## 2. When your target Linux device does NOT have the `bash` shell, and you must use the `busybox` `ash` (preferred) or `sh` shell instead

<a id="here-are-some-basic-dumbed-down-~profile-and-~bashrc-configuration-files-you-can-use-for-your-target-embedded-linux-device-if-you-like"></a>
### Here are some basic, dumbed-down `~/.profile` and `~/.bashrc` configuration files you can use for your target embedded Linux device if you like:

`~/.profile_for_remote`:  
```bash
# Source the .bashrc file
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
```

`~/.bashrc_for_remote`:  
```bash
# Set Prompt String 1 (PS1) variable to show colors, present working dir (pwd), and to set the
# terminal title to the current folder (all but setting the terminal title is borrowed from Ubuntu)

PS1_NO_TITLE='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
TITLE='[$(hostname)] $(basename "$(pwd)")'
# Set the PS1 title escape sequence; see "Customizing the terminal window title" here:
# https://wiki.archlinux.org/index.php/Bash/Prompt_customization#Customizing_the_terminal_window_title
# See also my `gs_set_title()` bash function somewhere around here:
# https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/blob/master/home/.bash_aliases#L250
ESCAPED_TITLE="\[\e]2;${TITLE}\a\]"
PS1="${PS1_NO_TITLE}${ESCAPED_TITLE}"

# Add `ll` aliases (all borrowed from Ubuntu's default /etc/skel/.bashrc file)
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
```

<a id="22-use-this-when-your-target-device-does-not-have-bash-so-you-must-use-ash-now-use-the-following-alias-to-ssh-into-the-target-device-and-auto-configure-your-ash-shell-environment-at-the-same-time"></a>
### [2/2: USE THIS WHEN YOUR TARGET DEVICE DOES NOT HAVE `bash`, SO YOU MUST USE `ash`] Now, use the following alias to ssh into the target device and auto-configure your `ash` shell environment at the same time

See [this answer to my question here](https://unix.stackexchange.com/a/677149/114401), as well as my comment underneath it. Notice that the key part of the alias below for use with the target `ash` shell is the `'export ENV=/tmp/.bashrc; ash'` command part at the end. Read about how `ash` uses this `ENV` environment variable in the `ash` documentation here: https://linux.die.net/man/1/ash.

```bash
# ensure ~/pw contains your password, assuming you want to do this instead of using ssh keys
echo 'my_ssh_password' > ~/pw

# Also ensure you've create the `~/.bashrc_for_remote` file with the contents above.

# Add this alias to your ~/.bash_aliases file on the machine you will be ssh-ing FROM
alias gs_ssh="sshpass -f ~/pw scp ~/.bashrc_for_remote root@192.168.0.2:/tmp/.bashrc \
&& sshpass -f ~/pw ssh -t -o 'ServerAliveInterval 60' root@192.168.0.2 'export ENV=/tmp/.bashrc; ash'"
```


<a id="3-dropbear-setup-and-notes-to-remotely-decrypt-a-luks-encrypted-hard-drive"></a>
# 3. Dropbear setup and notes to remotely decrypt a LUKS-encrypted hard drive

_How to use the Dropbear ssh server to remotely decrypt your LUKS-encrypted Linux hard drive after reboot so you can then ssh in._

<a id="references-2"></a>
## References:
1. [Google search for "configure dropbear to decrypt drive"](https://www.google.com/search?q=configure+dropbear+to+decrypt+drive&sxsrf=AOaemvI-i7iWwaLwb-TjbKExYGXM_c5BUQ%3A1639435566248&ei=Ls23YcuxDu3b0PEPpdSs2Ag&ved=0ahUKEwjLgLu07eH0AhXtLTQIHSUqC4sQ4dUDCA4&uact=5&oq=configure+dropbear+to+decrypt+drive&gs_lcp=Cgdnd3Mtd2l6EAMyBQghEKABMgUIIRCgAToHCAAQRxCwAzoGCAAQFhAeOgUIIRCrAjoFCAAQzQI6CAghEBYQHRAeSgQIQRgASgQIRhgAULEIWMI4YP85aAdwAngBgAGPAogBjB2SAQYxLjIzLjGYAQCgAQHIAQjAAQE&sclient=gws-wiz)
1. \*\*\*\*\*[How to unlock LUKS using Dropbear SSH keys remotely in Linux](https://www.cyberciti.biz/security/how-to-unlock-luks-using-dropbear-ssh-keys-remotely-in-linux/)

Follow the link just above from CyberCiti.biz. Here's the gist of it:

<a id="1-background-and-learning"></a>
## 1. Background and learning
```bash
# Firt, install Linux Ubuntu with LVM and LUKS encryption. Done.

# Note: you can manually see kernel boot dirs like this:
ls -1 /boot/*$(uname -r)*
# "vmlinuz is my Linux kernel, and initrd contains Linux drivers, RAID support, Dropbear ssh server,
#  and other stuff to boot the Linux system."

# View which of your partitions and mounts are under type "crypto_LUKS" as "LVM2_member" types. 
# These are encrypted.
lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT
# and
sudo cat /etc/crypttab
```

<a id="2-the-actual-steps-to-set-up-dropbear"></a>
## 2. The actual steps to set up Dropbear

```bash
# Install dropbear-initramfs onto the computer you'd like to ssh INTO
sudo apt update
sudo apt install dropbear-initramfs
# You may see some warnings, such as “dropbear: WARNING: Invalid authorized_keys file, remote
# unlocking of cryptroot via SSH won't work!“. Just ignore these warnings for now, as we are about
# to set up a custom dropbear authorized_keys file at "/etc/dropbear-initramfs/authorized_keys" in
# the coming steps anyway.

# Edit the "/etc/dropbear-initramfs/config" file
sudo nano /etc/dropbear-initramfs/config
# Manually uncomment the "DROPBEAR_OPTIONS" line by deleting the `#` char, and make it look like 
# this (again, withOUT the `#` char and withOUT the spaces in front):
#       DROPBEAR_OPTIONS="-s -p 2222 -j -k -I 60"
# See `man dropbear` for all of these options.
# - The `-s` disables password logins, for security, allowing only ssh key-based logins.
# - The `-p 2222` sets the port to 2222. The default ssh port is always 22, so it's more secure to
#   make it anything other than this, as this automatically makes it harder for an adversary to
#   know to attack this port. `2222` is just an example. Set it to any number 1 through 65535,
#   favoring a higher number, as many of the lower ports are already taken! See:
#   https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
# - The `-j` disables local port forwarding.
# - The `-k` disables remote port forwarding.
# - The `-I 60` sets an "idle timeout" of 60 seconds, disconnecting any ssh connection which is
#   idle for longer than this.
# Optionally add `-b /etc/dropbear/banner` too if you'd like to have dropbear display a certain
# text banner whenever someone ssh's into it. 
# Save and exit the editor.


# Optionally configure a static IP for your Dropbear ssh server, by editing your 
# "/etc/initramfs-tools/initramfs.conf" file. Ex: adding this line to that file:
#       IP=192.168.2.19::192.168.2.254:255.255.255.0:debian
# ...means: 
# IPv4 = 192.168.2.19
# Gateway = 192.168.2.254
# Netmask = 255.255.255.0
# Hostname = debian 
#
# [MY PREFERENCE] I prefer to set a static IP in my DHCP server in my router, however, rather than
# inside my PC. So, optionally do that if you like. 

# Update your initramfs filesystem image to be used at boot; this brings in the changes we made
# to the "/etc/dropbear-initramfs/config" config file just above.
sudo update-initramfs -u -v

# On the computer you'd like to ssh FROM:
# 1. Create rsa-based ssh keys for login (dropbear doesn't yet support the better ed25519 type)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/id_rsa_dropbear
# 2. Ensure the ssh-agent is running
eval "$(ssh-agent -s)"
# 3. Add your ssh key to the `ssh-agent`
ssh-add ~/.ssh/id_ed25519

# One way or another, append the **public** ("~/.ssh/id_rsa_dropbear.pub") key just generated above
# on the ssh-FROM-computer to the "/etc/dropbear-initramfs/authorized_keys" file on the 
# SSH-TO-computer.
# See the "FILES" section of `man dropbear` and read all about the "Authorized Keys" file options
# you can add just before your public key entry. 
# =======> The form of each line entry is this: <=======
#       [restrictions] ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIgAsp... [comment]
# So, make your entry look like this:
#       no-port-forwarding,no-agent-forwarding,no-x11-forwarding,command="/bin/cryptroot-unlock" ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIgAsp...
# The man pages say: "Restrictions are comma separated, with double quotes around spaces in
# arguments." Note that the `command="/bin/cryptroot-unlock"` part is optional. You can completely
# leave it out if you want--you'll just have to manually type the command each time you ssh into
# the dropbear server is all.

# When done configuring "/etc/dropbear-initramfs/config"
# and "/etc/dropbear-initramfs/authorized_keys" above, you can view the contents of all files
# like this, just to double-check them:
sudo grep --color=always '' /etc/dropbear-initramfs/*


# Now that you've added a public ssh key to your dropbear
# server's "/etc/dropbear-initramfs/authorized_keys" file: Update your initramfs filesystem image
# to be used at boot to bring in these changes.
sudo update-initramfs -u -v

# Reboot your server
sudo reboot

# Ping the server (the ssh TO computer) from your ssh FROM computer to see when it's alive:
ping 192.168.2.19

# ssh into your dropbear server from your FROM computer; be sure to use "root" as your username
# for this connection so you can unlock your LUKS encryption **as root**! Use the port you set
# previously on the server above.
ssh root@192.168.2.19 -p 2222 -i ~/.ssh/id_rsa_dropbear 

# If you have the `command="/bin/cryptroot-unlock"` part in
# the "/etc/dropbear-initramfs/authorized_keys" file on the server, that command will automatically
# be run and let you type in the password to decrypt your LUKS encryption.
# If you do NOT have that command as part of the authorized_keys file, type it manually now that
# you've sshed into dropbear:
cryptroot-unlock
# Type in your LUKS encryption password. The dropbear ssh connection will automatically close, and 
# the system will boot. Give it a minute or so and then ssh in like normal!
```

Useful aliases for your `~/.bash_aliases_private` file:
```bash
alias gs_ssh='ssh -X -o "ServerAliveInterval 60" username@192.168.2.19'
alias gs_ssh_dropbear='ssh root@192.168.2.19 -p 2222 -i ~/.ssh/id_rsa_dropbear'
```

<a id="3-test-it-reboot-ssh-in-to-dropbear-decrypt-your-hard-drive-and-ssh-in-like-normal"></a>
## 3. Test it: reboot, ssh in to dropbear, decrypt your hard drive, and ssh in like normal

Now, after rebooting your server computer, the process to decrypt its LUKS hard drive and ssh in will simply be:
```bash
# Reboot server, then:

gs_ssh_dropbear
# Manually type LUKS decryption password now, and wait ~60 seconds, then:
gs_ssh
# Done! You're in!
```



---

<sub>Keywords: ssh instructions; ssh readme; ssh public/private key setup; ssh public-private key setup; set up your public and private ssh keys</sub>
