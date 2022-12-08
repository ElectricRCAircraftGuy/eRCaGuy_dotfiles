This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


This is a sample .ini configuration file from `$HOME/eclipse/cpp-2022-09/eclipse/eclipse.ini`. 

Things I changed are:

```bash
-Xms1024m   # increased from 256 MB I think
-Xmx12288m  # increased from 2048 MB I think, since indexing takes so much memory

-Declipse.p2.max.threads=4  # decreased from 10 threads
```

**I decreased from 10 to 4 threads using the line just above in an attempt to keep the Eclipse indexer from sucking up all my resources!** My PC has 8 cores (hyper-threads, actually), so setting it to 4 threads max leaves 4 threads to process other computer stuff, hopefully keeping my computer from freezing and becoming unusable all the stinking time! If that's not enough, further reduce the number of threads available to Eclipse: ex: reduce it to 3 or even 2 threads if necessary to keep it from bogging down your system all the time! Giving it up to _half as many threads as you have cores_ is a reasonable start, however (ex: give it up to 4 threads if you have 8 cores, so it'll only use up to half your cores). See my detailed answer here: [Problem: Eclipse and the Eclipse indexer take up all my resources / CPU%](https://stackoverflow.com/a/74707607/4561887).


## See also

1. My Eclipse setup doc: [Eclipse setup instructions on a new Linux (or other OS) computer](https://docs.google.com/document/d/1LbuxOsDHfpMksGdpX5X-7l7o_TIIVFPkH2eD23cXUmA/edit?usp=sharing)
    1. [Troubleshooting](https://docs.google.com/document/d/1LbuxOsDHfpMksGdpX5X-7l7o_TIIVFPkH2eD23cXUmA/edit#heading=h.6kego5424sh1) section of that doc
1. \*\*\*\*\* My detailed answer: [Problem: Eclipse and the Eclipse indexer take up all my resources / CPU%](https://stackoverflow.com/a/74707607/4561887)


