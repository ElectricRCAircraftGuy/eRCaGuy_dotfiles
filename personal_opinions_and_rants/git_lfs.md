This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


# Git LFS is evil

Git LFS is horrible. Don't use it except with careful consideration and as a last resort.

Why?

1. It makes `git checkout` go from being an instantaneous _offline_ command to being an _online_ command that takes up to 3\~4 hours in extreme cases (which I dealt with for 3 years). read more [in my question here](https://stackoverflow.com/q/75946411/4561887).
2. It stores data less efficiently than native git. See my answer here: [How does git LFS track and store binary data more efficiently than git?](https://stackoverflow.com/a/76567696/4561887)
3. Once added, it cannot be fully removed from a repo except by deleting the repo and starting over, losing all commit history. See [GitHub's official documentation here](https://docs.github.com/en/repositories/working-with-files/managing-large-files/removing-files-from-git-large-file-storage#git-lfs-objects-in-your-repository) (emphasis added): 

    > After you remove files from Git LFS, the Git LFS objects still exist on the remote storage and will continue to count toward your Git LFS storage quota.
    > 
    > To remove Git LFS objects from a repository, **delete and recreate the repository.**

    Yeah...I'm shocked too. That's totally nuts.


# The following was originally at the top of my answer here: https://stackoverflow.com/revisions/72610495/19. 

[What is the difference between `git lfs fetch`, `git lfs fetch --all`, and `git lfs pull`?](https://stackoverflow.com/a/72610495/4561887). 

---

Update 5 May 2023: to anyone thinking of using `git lfs`, _don't_! See my explanation in my question here, in this section: [Update: don't use `git lfs`. I now recommend _against_ using `git lfs`](https://stackoverflow.com/q/75946411/4561887), and [in my answer here](https://stackoverflow.com/a/76567696/4561887). 

For personal, free GitHub accounts, it is way too limiting, and for paid, corporate accounts, it makes `git checkout` go from taking a few seconds to [up to 3+ _hours_](https://stackoverflow.com/q/68552775/4561887), especially for remote workers, which is a total waste of their time. I dealt with that for three years and it was horrible. I wrote a script to do a `git lfs fetch` once per night to mitigate this, but my employer refused to buy me a bigger SSD to give me enough space to do `git lfs fetch --all` once per night, so I still ran into the multi-hour-checkout problem frequently. It's also impossible to undo the integration of `git lfs` into your repo unless you _delete_ your whole GitHub repo and recreate it from scratch.

In both cases: corporate and free, with over 3 years of daily experience using it, I have found `git lfs` to be a massive time-waster.

If you are forced to use `git lfs` by your employer, however, here's what you need to know:

---

Now [on to the answer...](https://stackoverflow.com/a/72610495/4561887)
