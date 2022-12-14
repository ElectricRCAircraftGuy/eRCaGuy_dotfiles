This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# General `crontab`/cron job (cronjob) info

## References

1. Google search for [linux configure cron job](https://www.google.com/search?q=linux+configure+cron+job&oq=linux+configure+cron+job&aqs=chrome.0.69i59.164j0j9&sourceid=chrome&ie=UTF-8)
1. \*\*\*\*\*https://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/
1. https://phoenixnap.com/kb/set-up-cron-job-linux
1. \*\*\*\*\*https://en.wikipedia.org/wiki/Cron - contains a nice graphical chart/image describing each column before the command to run
    1. https://en.wikipedia.org/wiki/Cron#Nonstandard_predefined_scheduling_definitions
1. \*\*\*\*\*+ This answer (which I heavily modified/improved) about modifying root's crontab to start a process as root after each reboot: [Ask Ubuntu: How to run a script during boot as root](https://askubuntu.com/a/290102/327339)


## Main commands

```bash
# User crontab
crontab -l  # list your user crontab entries
crontab -e  # edit your user crontab entries--ex: to manually add new ones

# Root crontab
# - NB: this is NOT the same thing as your user crontab! 
#   Entries in this root list will run as root.
sudo crontab -l  # list root's crontab entries
sudo crontab -e  # edit root's crontab entries--ex: to manually add new ones
```


## Format
The format is like this. 
See: https://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/
```bash
* * * * * command to be executed
- - - - -
| | | | |
| | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
| | | ------- Month (1 - 12)
| | --------- Day of month (1 - 31)
| ----------- Hour (0 - 23)
------------- Minute (0 - 59)
```

An asterisk (`*`) is a wildcard and means "all of these times". Example: an asterisk (`*`) in the "Day" slot at the far right means "every day", and in the "Month" slot just to the left of that means "every month". 

#### Nonstandard predefined scheduling definitions:

See here for details https://en.wikipedia.org/wiki/Cron#Nonstandard_predefined_scheduling_definitions: 

```
Entry                   Description                                                 Equivalent to
------                  -----------                                                 -------------
@yearly (or @annually)  Run once a year at midnight of 1 January                    0 0 1 1 *
@monthly                Run once a month at midnight of the first day of the month  0 0 1 * *
@weekly                 Run once a week at midnight on Sunday morning               0 0 * * 0
@daily (or @midnight)   Run once a day at midnight                                  0 0 * * *
@hourly                 Run once an hour at the beginning of the hour               0 * * * *
@reboot                 Run at startup                                              —
```

The `@reboot` one is really useful to run something at startup!


## Examples


Run `crontab -e` then add to the user crontab file:
```bash
# Run a Cron Job at 2 am Every Day; see: https://phoenixnap.com/kb/set-up-cron-job-linux
0 2 * * * "/path/to/eRCaGuy_dotfiles/useful_scripts/cronjobs/repo_git_pull_latest.sh"
```

Run `sudo crontab -e` then add to the root crontab file (all entries run as root even withOUT using `sudo`):
```bash
# Start up the CPU logger every time cron is restarted (typically only at system boot)
# - Note: `sudo` before the cmd below is NOT required since this is being added to the root's
#   crontab already, with `sudo` via `sudo crontab -e`, and is therefore run as root directly 
#   instead.  
@reboot chrt -rr 1 "/home/gabriel/GS/dev/eRCaGuy_dotfiles/useful_scripts/cpu_logger.py"
```


# How to create a cron job to run `git pull` & `git lfs pull` every night at 2am


```bash
# Open the crontab editor
crontab -e
# Paste this cronjob cmd into it. Update all of the variables which precede the command, as
# necessary, to configure it to your needs. When done, save the file and exit.
0 2 * * * REMOTE_NAME="origin" MAIN_BRANCH_NAME="main" PATH_TO_REPO="$HOME/GS/dev/some_repo" "$HOME/GS/dev/eRCaGuy_dotfiles/useful_scripts/cronjobs/repo_git_pull_latest.sh"
# When done, verify your entry by listing (`-l`) all cron jobs in the crontab file.
# See: https://phoenixnap.com/kb/set-up-cron-job-linux
crontab -l

# (Optional): **manually** run and test your cronjob you just created above, by simply copy/pasting
# the command-portion of the cronjob entry above into your terminal
REMOTE_NAME="origin" MAIN_BRANCH_NAME="main" PATH_TO_REPO="$HOME/GS/dev/some_repo" "$HOME/GS/dev/eRCaGuy_dotfiles/useful_scripts/cronjobs/repo_git_pull_latest.sh"
# Now, view your log to ensure it logged properly
cat ~/cronjob_logs/repo_git_pull_latest.sh.log
```
