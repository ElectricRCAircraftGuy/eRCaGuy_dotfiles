# PC-to-PC Git-based Folder/Project Sync Script: 

Sync a **50\~100+ GB folder** containing **100k \~ 1M+ files** from PC1 to PC2 over a **cell phone WiFi hotspot** using as little as **25\~50 MB of cellular data** in **20 seconds \~ 2 minutes**.

    sync_git_repo_from_pc1_to_pc2.sh

## Description & Details:

This is an incredibly powerful and useful script, so I'm giving it a section all on its own. 

1. Sometimes you need to develop software on one machine (ex: a decent laptop, running an IDE like Eclipse) 
   while building on a remote server machine (ex: a powerful desktop, or a paid cloud-based server such as 
   AWS or Google Cloud--like this guy: https://matttrent.com/remote-development/). The problem, however, 
   is **"how do I sync from the machine I work on (ex: Personal Computer 1, or PC1) to the machine I build on
   (ex: Personal Computer 2, or PC2)?"**.  
   This script answers that problem. It uses `git` to sync from one to the other. Git is 
   preferred over `rsync` or other sync tools since they try to sync *everything* and on large repos 
   they take FOREVER (dozens of minutes, to hours)! This script is lightning-fast (seconds) and 
   ***safe***, because it always backs up any uncommitted changes you have on either PC1 or PC2
   before changing anything!
1. A typical run on a directory containing **hundreds of thousands of files** and **50~100 GB of data** might take **20 seconds ~ 2 minutes max** (30\~45 seconds is typical), and require **\~25 MB of WiFi/cellular data** is all! This is a very small amount of data compared to other options when syncing very large repos, and this is something which you care about if running on a hotspot from your cell phone.
1. Run it from the *client* machine where you develop code (PC1), NOT the server where you will build or otherwise test or use the code (PC2)!
1. It MUST be run from a directory inside the git repo you are syncing FROM.

## Installation and Usage:

See the headers at the top of these files for additonal information, installation, and usage:

1. "eRCaGuy_dotfiles/useful_scripts/sync_git_repo_from_pc1_to_pc2.sh"
2. "eRCaGuy_dotfiles/.sync_git_repo"

**See also this answer and writeup on StackOverflow:  
[Gabriel Staples' Stack Overflow answer for how to "Work on a remote project with Eclipse via SSH"](https://stackoverflow.com/questions/4216822/work-on-a-remote-project-with-eclipse-via-ssh/60315754#60315754)**

Essentially, you just:

1. Copy the `.sync_git_repo` file to `~/.sync_git_repo`, and update its parameters.
1. Manually set up your ssh keys to be able to ssh from PC1 to PC2, and then:
1. Run the `path/to/eRCaGuy_dotfiles/useful_scripts/sync_git_repo_from_pc1_to_pc2.sh` script from any directory *inside the git repo* on PC1. 

This also assumes that PC2 already has the repo cloned--same as on PC1, and that all your ssh keys are set up and functioning to both:

- A) push and pull to/from the remote git repo on both PC1 and PC2, and 
- B) ssh from PC1 into PC2. 

Again, see the instructions in the files referenced above, and (even easier) at the Stack Overflow answer linked-to above. 