This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

Also published here: [How to use "openconnect" (via the `openconnect-sso` wrapper) with SAML and Duo two-factor authentication via Okta Single-Sign-on (SSO)](https://superuser.com/a/1753172/425838)


## How to use "openconnect" (via the `openconnect-sso` wrapper) with SAML and Duo two-factor authentication via Okta Single-Sign-on (SSO)

_Tested on Ubuntu 18.04._  
_I have blacked out appropriate parts of the screenshots for my security._

Cisco AnyConnect is an *incredibly* restrictive VPN client. It routes **all** traffic though the VPN and blocks **all** local connections once connected to the VPN. 

My preferred way to solve this is to simply use [OpenConnect](https://www.infradead.org/openconnect/) instead. It is compatible with Cisco AnyConnect servers and its client allows local connections even when the VPN is connected, routing only necessary traffic through the VPN (via [split tunneling](https://en.wikipedia.org/wiki/Split_tunneling)) to reach endpoints which are otherwise unavailable without the VPN. _Therefore, `openconnect` solves this problem and allows LAN access while connected to a Cisco VPN._


## Example 1: Simple `openconnect` example with Duo Two-factor authentication

Here is an example of how to connect to the Rice University VPN using `openconnect`: [kb.rice.edu: VPN: openconnect VPN for Linux using Duo Authentication](https://kb.rice.edu/page.php?id=113148):

```bash
# install
sudo apt update 
sudo apt install vpnc-scripts openconnect

# connect
# NB: for the **second password** field when running the commands below, type
# `pin`, `push`, `phone`, or `sms` to specify how you'd like to receive your 
# two-factor authentication request. Add a number to the end of the command if
# you have multiple registered devices. Ex: `push2`, `phone2`, `sms2`, etc.

# Option 1: runs in the background
openconnect -b --quiet --user=netID --authgroup=RiceNet connect.rice.edu
# Option 2: runs in the background
openconnect -b --quiet --no-dtls --user=netID --authgroup=RiceNet connect.rice.edu

# Option 3: runs in the foreground
openconnect --no-dtls connect.rice.edu
```

**To disconnect**, use <kbd>Ctrl</kbd> + <kbd>C</kbd> in the terminal if running the process in the foreground. Or, if running the process in the background, open any terminal and run one of the following commands:

```bash
# to cleanly kill openconnect or openconnect-sso
sudo pkill --signal SIGINT openconnect
# or (same thing)
sudo pkill -SIGINT openconnect
```

See more details in my answer here: [How to shut down `openconnect` cleanly?](https://unix.stackexchange.com/a/725171/114401)


## Example 2 [What I use]: using the `openconnect-sso` wrapper for SAML authentication via Okta Single-Sign-on (SSO) and Duo two-factor authentication

My case is more complex, so I can't use [`openconnect`](https://www.infradead.org/openconnect/) by itself. Instead, I must **use the [`openconnect-sso`](https://github.com/vlaci/openconnect-sso) "OpenConnect Single Sign-On (SSO)" wrapper which allows SAML 2-factor authentication via [Okta](https://www.okta.com/)**, in place of the Cisco AnyConnect client. 

I found installing `openconnect-sso` to be [incredibly difficult due to some simple dependency problems](https://github.com/vlaci/openconnect-sso/issues/111), but these instructions should make it easy for you:

```bash
sudo apt update
sudo apt install vpnc-scripts openconnect   # install openconnect
sudo apt install python3

python3 -m pip install --upgrade pip
python3 -m pip install openconnect-sso      # install openconnect-sso

# install openconnect-sso dependencies, including forcing a reinstall of PyQt5

# uninstall
python3 -m pip uninstall PyQt5
python3 -m pip uninstall PyQt5-sip
python3 -m pip uninstall PyQtWebEngine
python3 -m pip uninstall keyring

# reinstall
python3 -m pip install PyQt5
python3 -m pip install PyQt5-sip
python3 -m pip install PyQtWebEngine
python3 -m pip install keyring

python3 -m pip install cffi

# Check the version
# My output is: `openconnect-sso 0.7.3`
openconnect-sso --version
```  

**Usage** (note: for how to find your server address and SAML group, see below):
```bash
VPN_SERVER_ADDRESS="myvpn.whatever.com"   # example server address to connect to
VPN_SAML_GROUP="whatever-saml-whatever"   # example SAML group name
VPN_USER="my.username@something.com"      # example username
# or perhaps just this for the username:
# VPN_USER="my.username"

# connect via `openconnect-sso`
# The first time ever, you must specify everything
openconnect-sso --server "${VPN_SERVER_ADDRESS}/${VPN_SAML_GROUP}" --user "${VPN_USER}"
# Subsequent connection attempts can be done with just this, since apparently
# the server address, SAML group, and username are cached after the first usage
openconnect-sso
```

**Screenshots and sequence of events during connecting:**

Once I run the `openconnect-sso` command above, this is what happens:

1. `openconnect-sso` opens up a web-page which is "Powered by Okta" (as stated at the bottom of it--see screenshot below) and which is requesting my Username and Password for Duo SSO (single sign-on) two-factor authentication. My username and password are already filled in--probably since I've done this before. It says, "We found some errors. Please review the form and make corrections." Ignore that error. I think this is just because the username and password were automatically typed in, and it doesn't detect them yet. To make it detect them, I just have to click in the username box on my already-typed-in username and press <kbd>Tab</kbd> twice. That interaction with the input boxes causes the form to detect that my username and password are present. It then automatically validates my username and password since they are already typed in, and then it loads a new web page. 
    [![enter image description here][5]][5]
1. On the new page, I make sure my correct phone number or device is selected in the "Device" box, then I click the "Send me a Push" button, and it sends a Duo two-factor authentication push request to my phone. I authenticate on my phone in the Duo app, then the webpage window automatically closes. 
    [![enter image description here][6]][6]

    _Note that in the screenshot above, it says my "computer software is out of date" simply because it wants me to update my version of the Chrome browser to the latest. If I don't do that at least every 10 days or so, the VPN server won't let me log in._

1. Next, in the terminal, `openconnect-sso` prints some statements that it has exited the browser (shown just below), then it requests my `sudo` password (also shown just below) for my Linux Ubuntu username so it can run as root to do the final VPN connection as root. I type that in and press <kbd>Enter</kbd>. It then finishes connecting to the VPN. The last several lines it prints out, starting with where it closed the browser window and then asked for my Linux `sudo` password, look as follows (note that I have changed my IP addresses in the output for my security):
    ```
    [info     ] Terminate requested.           [webengine] 
    [info     ] Exiting browser                [webengine] 
    [info     ] Browser exited                 [openconnect_sso.browser.browser] 
    [info     ] Response received              [openconnect_sso.authenticator] id=success message=
    [sudo] password for gabriel: 
    Connected to xxx.xxx.xxx.x:443
    SSL negotiation with myvpn.whatever.com
    Server certificate verify failed: signer not found
    Connected to HTTPS on myvpn.whatever.com
    Got CONNECT response: HTTP/1.1 200 OK
    CSTP connected. DPD 30, Keepalive 20
    Connected as xx.xxx.x.xxx + aaaa:bbbb:cccc::ddd/64, using SSL
    Established DTLS connection (using GnuTLS). Ciphersuite (DTLS0.9)-(DHE-RSA-4294967237)-(AES-256-CBC)-(SHA1).
    ```
1. Success! I am now fully connected to the VPN, yet _I still have full access to my local LAN and can ssh into my local embedded-Linux boards!_ 

Again, **to disconnect**, use <kbd>Ctrl</kbd> + <kbd>C</kbd> in the terminal running the process in the foreground. Or, open any terminal and run one of the following commands:

```bash
# to cleanly kill openconnect or openconnect-sso
sudo pkill --signal SIGINT openconnect
# or (same thing)
sudo pkill -SIGINT openconnect
```

See more details in my answer here: [How to shut down `openconnect` cleanly?](https://unix.stackexchange.com/a/725171/114401):

> If you use `sudo pkill openconnect` instead, it sends the default `SIGTERM` termination signal instead, which force-kills it and does _not_ kill it cleanly. If you make this simple mistake, simply turn your WiFi card OFF then back ON again by toggling it with <kbd>Fn</kbd> + <kbd>F8</kbd> or equivalent (look for the wifi beacon icon) on your laptop keyboard. This resets your internet connection so your internet will work again. 


## How to find your VPN server address and SAML group

Tested with Cisco AnyConnect Secure Mobility Client version 4.10.05085 on Linux Ubuntu 18.04:

[![enter image description here][1]][1]

1. Open the Cisco AnyConnect client and click the "VPN" tab. It will look like this. _Your VPN server address is what is shown in the "Connect to" box._
    [![enter image description here][2]][2]
1. Click the "Connect" button and it will open up a "Powered by Okta" "Duo SSO" window in a new browser window. 
    1. That browser window looks like this:
        [![enter image description here][3]][3]
    1. The Cisco AnyConnect window now shows a "Group" box _which shows your SAML Group:_
        [![enter image description here][4]][4]
1. Use that VPN server address and SAML Group name in the `openconnect-sso` command above. 


## Example 2 troubleshooting

If you can't get the PyQt5 or other dependencies to work with plain Python3, then it may be because your Python3 version is too old. Try forcefully installing and using a later version of Python3 like this. For example, if I wanted to use Python3.8 it would look like this:

```bash
sudo apt update
sudo apt install vpnc-scripts openconnect   # install openconnect
sudo apt install python3.8

python3.8 -m pip install --upgrade pip
python3.8 -m pip install openconnect-sso      # install openconnect-sso

# install openconnect-sso dependencies, including forcing a reinstall of PyQt5

# uninstall
python3.8 -m pip uninstall PyQt5
python3.8 -m pip uninstall PyQt5-sip
python3.8 -m pip uninstall PyQtWebEngine
python3.8 -m pip uninstall keyring

# reinstall
python3.8 -m pip install PyQt5
python3.8 -m pip install PyQt5-sip
python3.8 -m pip install PyQtWebEngine
python3.8 -m pip install keyring

python3.8 -m pip install cffi

# Check the version
# My output is: `openconnect-sso 0.7.3`
openconnect-sso --version
```


## Other tips

You can view various info. about your VPN server like this (source: https://gitlab.com/openconnect/openconnect/-/issues/84):
```bash
openconnect --dump -vvvv myvpn.whatever.com
```


## References

Here are most of the additional references I had to look at to figure out some of the dependency and related info. above.

1. https://kb.rice.edu/page.php?id=113148
1. https://github.com/dlenski/openconnect/issues/116
1. \*\*\*\*\*[Python 3.7.0 No module named 'PyQt5.QtWebEngineWidgets'](https://stackoverflow.com/a/54947671/4561887)
1. [No module named \_cffi\_backend](https://stackoverflow.com/a/50486955/4561887)
1. https://github.com/Nike-Inc/gimme-aws-creds/issues/158
1. https://bobbyhadz.com/blog/python-no-module-named-pyqt5
1. [my answer] [How to install PyQt5 in Python3](https://stackoverflow.com/a/74465762/4561887) and [here](https://stackoverflow.com/a/74465810/4561887)
1. \*\*\*\*\* The openconnect-sso link at the very top of this thread is how I first learned of openconnect-sso!: https://gitlab.com/openconnect/openconnect/-/issues/84
1. [my Q&A] [Disable VPN for certain local devices, such as an embedded Linux board I need to ssh into (Allow local (LAN) access when using VPN)](https://askubuntu.com/q/1437348/327339)
1. [my answer] [How to shut down openconnect cleanly?](https://unix.stackexchange.com/a/725171/114401)
1. https://github.com/vlaci/openconnect-sso
    1. All issues I opened: https://github.com/vlaci/openconnect-sso/issues?q=is%3Aissue+author%3AElectricRCAircraftGuy+
    1. [my issue] [ModuleNotFoundError: No module named 'PyQt5' [solved; please update installation instructions with this info]](https://github.com/vlaci/openconnect-sso/issues/111)
1. https://github.com/dlenski/openconnect/issues/143
1. https://gitlab.com/openconnect/openconnect/-/issues/84
1. [Google search for "open connect with duo two factor authentication"](https://www.google.com/search?q=open+connect+with+duo+two+factor+authentication&oq=open+connect+with+duo+two+factor+authentication&aqs=chrome..69i57j69i59j69i64j69i65j69i61j69i65j69i60.226j0j9&sourceid=chrome&ie=UTF-8)
1. \*\*\*\*\* [Google search for `"openconnect" with duo two factor authentication and "okta"`](https://www.google.com/search?q=%22openconnect%22+with+duo+two+factor+authentication+and+%22okta%22&oq=%22openconnect%22+with+duo+two+factor+authentication+and+%22okta%22&aqs=chrome..69i57j69i65.233j0j9&sourceid=chrome&ie=UTF-8)
1. https://www.reddit.com/r/archlinux/comments/8wclaz/openconnect_and_two_factor_auth/
1. https://duo.com/docs/okta
1. [my answer] [Cisco Anyconnect not working on Ubuntu 18.04 with two-factor authentication](https://askubuntu.com/a/1441127/327339)
1. official `openconnect` repo--I think!: https://gitlab.com/openconnect/openconnect
1. https://docs.python-guide.org/starting/install3/linux/
1. [Dealing with multiple Python versions and PIP?](https://stackoverflow.com/a/41412605/4561887)

<!--
For anyone who stumbles upon this thread but is looking for something slightly different, I just wrote this and it might be relevant to your case: [How to use "openconnect" (via the `openconnect-sso` wrapper) with SAML and Duo two-factor authentication via Okta Single-Sign-on (SSO)](https://superuser.com/a/1753172/425838)
-->


  [1]: https://i.stack.imgur.com/jTsZh.png
  [2]: https://i.stack.imgur.com/C8JN2.png
  [3]: https://i.stack.imgur.com/ieiia.png
  [4]: https://i.stack.imgur.com/P2Z64.png
  [5]: https://i.stack.imgur.com/9QX4h.png
  [6]: https://i.stack.imgur.com/fhTwK.png

