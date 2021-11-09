This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Table of Contents
<details>
<summary><b>(click to expand)</b></summary>
<!-- MarkdownTOC -->

1. [`ssh` key generation, setup, and configuration notes:](#ssh-key-generation-setup-and-configuration-notes)
    1. [References:](#references)
    1. [Example of files you may have in your `~/.ssh` dir](#example-of-files-you-may-have-in-your-~ssh-dir)
    1. [Public/Private ssh generation and copying to your server's `~/.ssh/authorized_keys` file](#publicprivate-ssh-generation-and-copying-to-your-servers-~sshauthorized_keys-file)
1. [How to source a custom .bashrc file whenever you ssh into a remote device](#how-to-source-a-custom-bashrc-file-whenever-you-ssh-into-a-remote-device)
    1. [References:](#references-1)
    1. [Command:](#command)
    1. [Optional \(but recommended\) Alias:](#optional-but-recommended-alias)
    1. [Apply Ubuntu's settings for ALL users who log into the `root` username on the target device](#apply-ubuntus-settings-for-all-users-who-log-into-the-root-username-on-the-target-device)

<!-- /MarkdownTOC -->
</details>


<a id="ssh-key-generation-setup-and-configuration-notes"></a>
# `ssh` key generation, setup, and configuration notes:

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
# legacy system that doesn't support the Ed25519 algorithm, use:"
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
# email the **public key** "~/.ssh/id_ed25519.pub" file to your remote server and graphically
# copy/paste it from your email, or whatever. 
```


<a id="how-to-source-a-custom-bashrc-file-whenever-you-ssh-into-a-remote-device"></a>
# How to source a custom .bashrc file whenever you ssh into a remote device

This is very useful, for example, when ssh-ing into an embedded Linux device or a shared device where you all ssh into the same username--ex: `root`, but you do NOT want to share a startup file nor modify it for others. Rather, you want to have your own custom aliases and environment and coloring and things. 

<a id="references-1"></a>
## References:
1. How to use `sshpass -p` and `sshpass -f`: https://stackoverflow.com/questions/50096/how-to-pass-password-to-scp/13955428#13955428
1. How to use `sshpass -f` _as though it was_ `sshpass -p`, but in a more-secure way, using _process substitution_ (`<()`): https://stackoverflow.com/questions/24454037/pass-a-password-to-ssh-in-pure-bash/24455773#24455773
1. [my question on _process substitution_] How to load files in `sh` from file descriptor 3 (`/dev/fd/3`), since _process substitution_ works in `bash` but NOT in `sh` shells, and since `/dev/fd/0` is already taken up as **stdin**, `/dev/fd/1` is **stdout**, and `/dev/fd/2` is **stderr**: https://unix.stackexchange.com/questions/676676/sh-syntax-error-unexpected-when-attempting-process-substitution-on-an-e/676681#676681
1. How to restore Ubuntu's default `~/.bashrc` file from `/etc/skel/.bashrc`: https://askubuntu.com/questions/404424/how-do-i-restore-bashrc-to-its-default/404428#404428

<a id="command"></a>
## Command:
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

<a id="optional-but-recommended-alias"></a>
## Optional (but recommended) Alias:
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
## Apply Ubuntu's settings for ALL users who log into the `root` username on the target device

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


---

<sub>Keywords: ssh instructions; ssh readme; ssh public/private key setup; ssh public-private key setup; set up your public and private ssh keys</sub>
