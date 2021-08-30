This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# `ssh` key generation, setup, and configuration notes:

## References:
1. [EXCELLENT!] Great background information on what ssh keys are and how they work, as well as how to use and create them:
https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server
1. [EXCELLENT!] Great, generic ssh key-generation steps and instructions, as well as how to add your public key to GitHub so you can access your repos remotely from the git command-line: 
https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
1. How to run commands over ssh: https://www.cyberciti.biz/faq/unix-linux-execute-command-using-ssh/

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
