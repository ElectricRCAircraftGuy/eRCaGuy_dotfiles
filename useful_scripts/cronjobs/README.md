This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# General `crontab`/cron job (cronjob) info

## References

1. Google search for [linux configure cron job](https://www.google.com/search?q=linux+configure+cron+job&oq=linux+configure+cron+job&aqs=chrome.0.69i59.164j0j9&sourceid=chrome&ie=UTF-8)
1. *****https://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/
1. https://phoenixnap.com/kb/set-up-cron-job-linux
1. *****https://en.wikipedia.org/wiki/Cron - contains a nice graphical chart/image describing each column before the command to run


## Main commands

```bash
crontab -l
    # list your crontab entries
crontab -e
    # edit your crontab entries--ex: to manually add new ones
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


## Examples

```bash
# Run a Cron Job at 2 am Every Day; see: https://phoenixnap.com/kb/set-up-cron-job-linux
0 2 * * * /path/to/eRCaGuy_dotfiles/useful_scripts/cronjobs/repo_git_pull_latest.sh
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
