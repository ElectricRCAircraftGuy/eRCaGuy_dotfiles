
# AIs (Artificial Intelligences)


## Using GitHub Copilot in the terminal/CLI

#### References
1. Using GitHub Copilot in the CLI - https://docs.github.com/en/copilot/github-copilot-in-the-cli/using-github-copilot-in-the-cli
1. https://docs.github.com/en/github-cli/github-cli/about-github-cli
1. \*\*\*\*\* Official GitHub CLI repo - https://github.com/cli/cli
    1. Linux installation: https://github.com/cli/cli/blob/trunk/docs/install_linux.md
1. Setting up GitHub Copilot in the CLI: https://docs.github.com/en/copilot/github-copilot-in-the-cli/setting-up-github-copilot-in-the-cli

#### Steps

1. Install `gh` (GitHub CLI) on Linux Ubuntu:
    ```bash
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
    ```

    See: https://github.com/cli/cli/blob/trunk/docs/install_linux.md

1. Enable Copilot in the CLI at the organization level

    (Only an admin of the organization can do this.)

    Log in to GitHub.com --> click profile photo in top-right --> Your organizations --> next to the organization name, click "Settings" --> In the "Code, planning, and automation" section of the sidebar, click "Copilot" --> "Policies" --> to the right of "Copilot in the CLI", select the dropdown menu, then click "Enabled".

    See: https://docs.github.com/en/copilot/github-copilot-in-the-cli/setting-up-github-copilot-in-the-cli

1. Ensure you have SSH keys set up to work with GitHub.com. 

    (I'm not going to explain this in detail. Ask me to if you need it.)

    GitHub has some instructions here: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent - see also the links in the navigation bar on the left. 

    I have generic/misc. SSH instructions here: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/tree/master/home/.ssh

1. Log in to GitHub.com through the CLI `gh` tool:
    ```bash
    # Log in to GitHub.com through the CLI
    gh auth login
    ```
    1. Use the up/down arrow keys to select the "GitHub.com" option, then press Enter.
    1. Since you have ssh keys set up, select the "SSH" option. 
    1. Choose the ssh key you have configured to use with GitHub.
    1. When it asks for a "Title for your SSH key", just press Enter to choose the default of "(GitHub CLI)".
    1. For "How would you like to authenticate GitHub CLI?", choose the default of "Login with a web browser". 
    
        Note that for `gh copilot` to work, you must NOT choose "Paste an authentication token" here. *Only* the "Login with a web browser" option will work. I tested and confirmed this, and [this comment](https://github.com/github/gh-copilot/issues/1#issuecomment-1802370972) confirms it too.

    1. Follow the instructions to authenticate via a web browser. 

        When done, the web browser will be at URL https://github.com/login/device/success and say: 

        > Congratulations, you're all set!
        >
        > Your device is now connected.

    References: 
    1. https://docs.github.com/en/copilot/github-copilot-in-the-cli/setting-up-github-copilot-in-the-cli
    1. Going through the process myself, with my own trial and error. 
    1. This issue and comment confirming that the "Paste an authentication token" option does not work: https://github.com/github/gh-copilot/issues/1#issuecomment-1802370972

1. Install the `gh-copilot` extension for `gh`:

    Now that you have a token and are logged in via `gh auth login` above, you can install the `gh-copilot` extension for `gh`:
    
    ```bash
    # Install the `gh copilot` extension
    gh extension install github/gh-copilot
    # Example output:
    #       ✓ Installed extension github/gh-copilot

    # Ensure it is updated
    gh extension upgrade gh-copilot
    # Example output:
    #       [copilot]: already up to date
    #       ✓ Successfully upgraded extension

    See: https://docs.github.com/en/copilot/github-copilot-in-the-cli/setting-up-github-copilot-in-the-cli. 

1. Install dependencies you will need for `gh copilot suggest` to fully work
    ```bash
    sudo apt update
    sudo apt install xsel
    ```

1. Learn how to use `gh copilot`

    See: https://docs.github.com/en/copilot/github-copilot-in-the-cli/using-github-copilot-in-the-cli. 

    ```bash
    # Run the `gh copilot explain` command with no args
    gh copilot explain

    # Show the `gh copilot explain` help menu
    gh copilot explain -h
    
    # Explain what the `du -sh | sort -h` command does
    gh copilot explain 'du -sh | sort -h'


    # Start an interactive session to find the command you need
    gh copilot suggest

    # Ask for help on how to "install git"
    gh copilot suggest 'install git'
    ```



<!--
# DELETED STUFF

1. [UPDATE: DO *NOT* DO THIS! DOES NOT WORK. MUST AUTHENTICATE VIA THE WEB INSTEAD. SEE: https://github.com/github/gh-copilot/issues/1#issuecomment-1802370972] Generate an authentication token to be used by the `gh` executable in your terminal. 

    _Note: The minimum required scopes are `repo`, `read:org`, `admin:public_key`._

    Log in to https://github.com/ -> click your profile photo in the top right -> "Settings" -> click "Developer settings" in the bottom of the left-hand pane -> "Personal access tokens" -> "Tokens (classic)". 

    That leads you here: https://github.com/settings/tokens.

    Click the "Generate new token" dropdown near the top right -> "Generate new token (classic)" -> enter your two-factor authentication code, if applicable -> fill out the information as follows:
    
    1. Enter a Note, like `gh CLI token MyComputerName`
    1. Change the "Expiration" as desired. Ex: I set it to 1 year by using "Custom" and entering a date 1 year from now.
    1. Check the following scope authorization boxes:
        1. `repo` - "Full control of private repositories"
        1. `read:org` - "Read org and team membership, read org projects"
        1. `admin:public_key` - "Full control of user public keys"
        
    -> Click the "Generate token" button at the bottom -> click the little copy icon just to the right of the generated token to copy it to your clipboard. You will need this token in the next step.

1. Log in to GitHub.com through the CLI `gh` tool:
    ```bash
    # Log in to GitHub.com through the CLI
    gh auth login
    ```
    1. Use the up/down arrow keys to select the "GitHub.com" option, then press Enter.
    1. Since you have ssh keys set up, select the "SSH" option. 
    1. Choose the ssh key you have configured to use with GitHub.
    1. When it asks for a "Title for your SSH key", just press Enter to choose the default of "(GitHub CLI)".
    1. For "How would you like to authenticate GitHub CLI?", choose "Paste an authentication token". It then says: 
        > Tip: you can generate a Personal Access Token here https://github.com/settings/tokens  
        > The minimum required scopes are 'repo', 'read:org', 'admin:public_key'.

    1. Paste in the token you generated in the previous step.
    1. Press Enter to complete this operation. You will see something like this:
        ```
        - gh config set -h github.com git_protocol ssh
        ✓ Configured git protocol
        ✓ SSH key already existed on your GitHub account: /home/gabriel/.ssh/id_ed25519.pub
        ✓ Logged in as ElectricRCAircraftGuy
        ```

    References: 
    1. https://docs.github.com/en/copilot/github-copilot-in-the-cli/setting-up-github-copilot-in-the-cli
    1. Going through the process myself, with my own trial and error. 

-->

