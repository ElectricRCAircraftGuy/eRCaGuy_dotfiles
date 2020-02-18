**This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles**

# NoMachine Readme

NoMachine is an EXCELLENT remote login program, with EXCELLENT file-sharing/mount abilities and EXCELLENT cross-platform support for Windows, Mac, Linux, iOS, Android, Raspberry Pi, and ARM. It is NOT open source, but is no cost to use.

https://www.nomachine.com/  

# Setup

## Download:
https://www.nomachine.com/download

## To enable key-based authentication to server:

References:  
READ THESE!

1. [How to set up key based authentication with NX protocol](https://www.nomachine.com/AR02L00785)
2. [Generating a new SSH key](https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

Essentially, just add your public key to the "$HOME/.nx/config/authorized.crt" file on the server. If the file doesn't exist, create it. Set its permissions to 0600. Here's one example of commands to do that:

**1) Run from _client_:**

Generate a new private/public key pair from the *client*; run this from the client:

    ssh-keygen -t rsa -b 4096 -C "your personal comment or email"

Copy the *public* (.pub) key only from client to server; run this from the client; notice the renaming of the file on the destination to avoid conflict with keys already generated on the server:

    scp ~/.ssh/id_rsa.pub username@server_hostname_or_ip:~/.ssh/id_rsa_nxclient.pub

**2) Run from _server_:**

Add public key now on server to proper NoMachine file; run this from the server:

    cat ~/.ssh/id_rsa_nxclient.pub >> ~/.nx/config/authorized.crt

And lastly set this file's permissions to 0600 to enable read/write on this file ONLY for the user (owner) of this file, for security:

    chmod 0600 ~/.nx/config/authorized.crt

## To *disable* password-based login to server:

NB: Do NOT do this until key-based authentication is set up & verified to be working, or else you'll lose the ability to remotely connect via NoMachine, & have to manually fix it remotely over ssh, or locally!

References:  
(Not exactly addressing this question, but indirectly helpful in figuring it out)

1. [Prevent password authentication with NX protocol and key-based authentication](https://forums.nomachine.com/topic/prevent-password-authentication-with-nx-protocol-and-key-based-authentication)
2. [The server.cfg and node.cfg files explained (for server v. 4 and later)](https://www.nomachine.com/AR02N00877)

Note: On Linux, server.cfg is located here: "/usr/NX/etc/server.cfg". 

*On the server*, edit server.cfg (`sudo gedit /usr/NX/etc/server.cfg`) and find this section:

    #
    # Specify how clients will have to authenticate to the server, by
    # default all the available methods are supported. This corresponds
    # to value all. To specify a subset of methods use a comma-separated
    # list.
    #
    # Supported methods for connections by NX protocol are:
    # NX-password   : Password authentication.
    # NX-private-key: Key-based authentication.
    # NX-kerberos   : Kerberos ticket-based authentication.
    #
    # Supported method for connections by SSH protocol is:
    # SSH-system    : All methods supported for the system login.
    #                 SSH authentication methods for the system login
    #                 have to be set on the system for example in the
    #                 PAM configuration.
    #
    # For example:
    # AcceptedAuthenticationMethods NX-private-key,SSH-system
    #
    # This key has to be used in conjunction with ClientConnectionMethod.
    # See also the EnableNXClientAuthentication key for enabling SSL
    # client authentication for connections by NX protocol.
    #
    #AcceptedAuthenticationMethods all

Now, just below this commented-out line indicating the default setting:

    #AcceptedAuthenticationMethods all

Add this line to change the setting to allow ONLY key-based authentication: 

    AcceptedAuthenticationMethods NX-private-key

Then restart the NoMachine server (https://www.nomachine.com/TR11N07362):

    sudo /usr/NX/bin/nxserver --restart

Now try to connect remotely using NoMachine with password-based authentication, and you should see the following error in the GUI program:

    Ooops! The session negotation failed. Error: Authentication method NX-password is not allowed on this server

If you saw the above error you have successfully disabled password authentication logins! Now test your key-based authentication to ensure it still works.

DONE!

