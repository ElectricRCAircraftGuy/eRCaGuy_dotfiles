This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# This is a `git submodule` "Quick Start" guide. Use it to get your team on-boarded.


# See also

1. [README.md](README.md)
1. [README.md: "_Git submodules and Git LFS:_ how to clone this repo and all git submodules and git lfs files"](README.md#how-to-clone-whole-repo)


# Help! My company is making me use git submodules! What do I do?


# Quick summary

1. A `git submodule` is git's official way to have a repo within a repo. 
1. From this point forward, follow every `git clone`, `git pull`, or `git checkout` with `git submodule update --init --recursive`, which you run inside the outer repo.
    1. The clone, pull, and checkout commands update the *pointers* to the submodules' commit hashes, without actually updating anything on your disk, while the `git submodule update --init --recursive` command updates the *contents* of the submodule directories on your disk to match the *contents* of each submodule's repository at each commit hash that the submodule pointers are pointing to.
1. `cd` into a submodule directory within your repo to work within that sub-repo. Submodules are just normal repos. They show up as regular folders within your outer repo, but their files get stored in their own repo on the remote server.
1. The outer repo stores a **pointer** to a specific commit hash in the inner repo. The outer repo doesn't actually store the inner repo's files on its remote server. 
1. Once you've updated a submodule, `cd` back up into your outer repo and run `git add my_submodule` and then `git commit` to commit and push your changes to the outer repo to point to the new commit hash of the inner repo/submodule.
1. Follow the "Update your terminal" instructions below before you begin working with submodules to minimize your chance of making mistakes. This automagically adds a `repo_dir  branch_name  commit_hash  git_tags` line above your terminal prompt so you always know which repo, branch, commit hash, and tags you are working on whenever you `cd` into a git repo or submodule.
1. Once you clone a repo with submodules, you no longer _need_ to separately clone the submodules into your highest working directly like you did the outer repo. Just cd into the submodules within the outer repo to update and work on them there. Whether or not you follow this workflow, though, is up to you.
1. Study and read the entire "Details" section below before you begin working with submodules.


# Details


# As a **user** of submodules

A `git submodule` is git's officially-supported way to allow you to have a repo within a repo. Nested, or "recursive", submodules are allowed. So you can have a repo within a repo within a repo, and so on. 

The way submodules work is that each repo has its own remote URL, so the outer repo containing the inner repo simply stores a **pointer** to a specific commit hash in the inner repo. On your file system, the inner repo is a **folder** within your outer repo, but in the remote git server, the inner repo is a **pointer file** to the other repo. 

Submodules are super easy to use, *if* you understand the above. As a *user* of a repo with submodules, you only need **1 single extra command**:

```bash
# Recursively update all git submodules to their commit hash pointers as
# currently committed in the outer repo.
git submodule update --init --recursive
```

That's it! Follow every `git clone`, `git pull`, or `git checkout` with `git submodule update --init --recursive`, like this: 
```bash
# 1. clone the outer rep and update submodule pointers
git clone path/to/some_repo
cd some_repo
# 2. update the filesystem (submodule dirs) to match those pointers
git submodule update --init --recursive

# 1. update the outer repo and submodule pointers
git pull
# 2. update the filesystem (submodule dirs) to match those pointers
git submodule update --init --recursive

# 1. check out a branch and its submodule pointers
git checkout some_branch
# 2. update the filesystem (submodule dirs) to match those pointers
git submodule update --init --recursive
```

This ensures that the **contents of your fle system** are always in sync with the **commit hash pointers** that the submodules are pointing to. If there are no submodules, running this command has no effect, so you can just get into the habit of running it if you're not sure.

If you ever run `git status` and see that the submodule has changes but you didn't change anything within it, then it means you did a pull or checkout or something on the outer repo and the **commit pointer** for that submodule has changed, but you didn't update the filesystem to match yet. So, run `git submodule update --init --recursive` to fix it.


# As a **maintainer** of the outer repo

A submodule is just a repo. So, `cd` into it and work on it like you would any other repo. When done, commit and push your changes. 

When you're ready to update the outer repo to point to the new commit hash of the submodule, do this:
1. `cd` back up into the outer repo. Ex: `cd ..`
1. Add and commit your changes to the outer repo to point to the new commit hash of the submodule:
    ```bash
    git add my_submodule
    git commit -m "Update my_submodule to commit hash 1234567"
    ```

If you ever want to forcefully update all submodules to their latest commit hash pointers, you can do this. Notice the addition of the `--remote` flag:
```bash
git submodule update --init --recursive --remote
git add -A
git commit -m "Update all submodules to their latest upstream changes"
```

Using the `--remote` flag is as if you manually `cd`ed into each subrepo and manually ran `git pull origin main` or equivalent to pull the latest changes from the upstream repo.

See my answer here: [Update Git submodule to latest commit on origin](https://stackoverflow.com/a/74470585/4561887). Study the comments above the commands below:

> ```bash
> # Option 1: as a **user** of the outer repo, pull the latest changes of the
> # sub-repos as previously specified (pointed to as commit hashes) by developers
> # of this outer repo.
> # - This recursively updates all git submodules to their commit hash pointers as
> #   currently committed in the outer repo.
> git submodule update --init --recursive
> 
> # Option 2. As a **developer** of the outer repo, update all subrepos to force
> # them each to pull the latest changes from their respective upstreams (ex: via
> # `git pull origin main` or `git pull origin master`, or similar, for each
> # sub-repo). 
> git submodule update --init --recursive --remote
> #
> # For just Option 2 above: now add and commit these subrepo changes 
> # you just pulled
> git add -A
> git commit -m "Update all subrepos to their latest upstream changes"
> ```

Adding a repo as a submodule inside another repo:
```bash
# General format
git submodule add URL_to_repo
# or
git submodule add URL_to_repo path/to/where/you/want/to/put/it
# then commit when done
git commit

# Examples:
git submodule add https://github.com/ElectricRCAircraftGuy/ripgrep_replace.git
git submodule add https://gitlab.com/ElectricRCAircraftGuy/systemd-by-example.git
git commit
# etc.
```

Removing a submodule from a repo ([see here](https://stackoverflow.com/a/1260982/4561887)):
```bash
git rm path/to/my_submodule
git commit
# delete the submodule metadata directory too
rm -rf .git/modules/my_submodule

# Example
git rm ripgrep_replace
git commit
rm -rf .git/modules/ripgrep_replace
```


# When building...

Ensure that `git status` does NOT show any changes in the submodules that you don't expect to see. If you run `git checkout some_branch` and that points to a new commit hash for your submodule, then you need to run `git submodule update --init --recursive` to update your filesystem to match the new commit hash pointer. If you don't, and then you build, **your build is broken** because you're building with the wrong submodule content on your file system!


# Update your terminal (this works in Git Bash on Windows too) to always show your git info at the command-line

Before you start working with submodules, I highly highly **highly** recommend you do the following to always show your `repo_dir  branch_name  commit_hash  git_tags` in your prompt. This way, your prompt will look like this, for example, whenever you `cd` into a git repo. As you can see here, above every `$` line in your prompt, if you are ever inside a git repo, you will automatically see the repo name, branch name, commit hash, and any tags, all in one line, so you never screw up whether you are editing the outer repo or a submodule, and you always know which branch and commit hash you are on. This is **invaluable** when working with submodules!:


_What you'll see in your terminal:_
```bash
$SHLVL:1 eRCaGuy_dotfiles  master  ca7dc5d (dirty)
gabriel:~/GS/dev/eRCaGuy_dotfiles$
```

### Installation instructions

Install the above magic into your terminal. This works on any OS, including Windows inside Git Bash: 

1. Ensure your Windows home dir is set correctly by following the instructions in my "Quick summary" here: [Stack Overflow: Change the location of the `~` directory in a Windows install of Git Bash](https://stackoverflow.com/a/77450145/4561887)
1. Close and re-opoen all Git Bash terminals you have open to make the home directory change take effect.  
1. Install the above prompt string magic into your terminal:
    ```bash
    # download this prompt string magic 
    curl -L https://raw.githubusercontent.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles/refs/heads/master/home/.bash_prompt_str > ~/.bash_prompt_str
    
    # add a command to automatically source it in the bottom of your .bashrc file
    echo -e "\n. ~/.bash_prompt_str" >> ~/.bashrc
    ```
1. Close and reopen all Git Bash terminals you have open, again, to make the prompt string take effect. 
1. Simply `cd` into any git repo and hit <kbd>Enter</kbd> a few times to see the magic in action. `cd`-ing into a submodule will show you are inside the submodule repo instead of the outer repo.
1. Done.


# Aliases

If `git submodule update --init --recursive` is too long for you, you can create an alias for it. Here's how:

```bash
git config --global alias.sub 'submodule update --init --recursive'
```

The above command adds the following alias to your `~/.gitconfig` file:

```bash
[alias]
	sub = submodule update --init --recursive
```

Now, you can just run `git sub` instead of `git submodule update --init --recursive`. 


# References and going further

1. Official `git submodule` documentation: https://git-scm.com/book/en/v2/Git-Tools-Submodules
1. My answer: [Git: How to make outer repository and embedded repository work as common/standalone repository?](https://stackoverflow.com/a/62368415/4561887)

    I mention that there are three tools to manage submodules:

    > 1. `git submodule` - https://git-scm.com/docs/git-submodule - the canonical, officially-supported tool built into `git`.
    > 1. `git subtree` - https://www.atlassian.com/git/tutorials/git-subtree
    > 1. `git subrepo` - https://github.com/ingydotnet/git-subrepo


