#!/usr/bin/env python3

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# STATUS: work-in-progress; NOT YET FUNCTIONAL!

# Print out basic stats on cpu load.

# INSTALLATION INSTRUCTIONS:#########3
# 1. Install RipGrep: https://github.com/BurntSushi/ripgrep#installation
# 2. Create a symlink in ~/bin to this script so you can run it from anywhere.
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/cpu_load.py" ~/bin/cpu_load            # required
#       ln -si "${PWD}/cpu_load.py" ~/bin/gs_cpu_load         # optional; replace "gs" with your initials
# 3. Now you can use this command directly anywhere you like in any of these ways:
#   1. `rgr`
#   2. `rg_replace`
#   1. `gs_rgr`
#   3. `gs_rg_replace`

# References: ########
# 1. https://askubuntu.com/questions/22021/how-to-log-cpu-load
# 1. https://unix.stackexchange.com/questions/295599/how-to-show-processes-that-use-more-than-30-cpu/295608#295608
# 1. https://stackoverflow.com/a/40088591/4561887
# 1. https://docs.python.org/3/library/logging.html

# Test commands:
#       eRCaGuy_dotfiles$ rgr foo -R boo
#       eRCaGuy_dotfiles$ rgr foo -R boo --stats "git & Linux cmds, help, tips & tricks - Gabriel.txt"


##### https://unix.stackexchange.com/a/295608/114401   <========

import logging
import psutil
import subprocess
import time

from logging.handlers import RotatingFileHandler
from pathlib import Path

# ============= this works but lets do it differently ==============
# MOVE THIS TO MY HELLO_WORLD REPO!
# cpu_percent_total = psutil.cpu_percent(interval=2)
# cpu_percent_cores = psutil.cpu_percent(percpu=True)
# cpu_percent_total_str = ('%.2f' % cpu_percent_total) + "%"
# cpu_percent_cores_str = [('%.2f' % x) + "%" for x in cpu_percent_cores]
# print('Total: {}'.format(cpu_percent_total_str))
# print('Individual CPUs: {}'.format('  '.join(cpu_percent_cores_str)))

# # Sanity check
# avg = sum(cpu_percent_cores)/len(cpu_percent_cores)
# print("DEBUG PRINT: avg = {:.2f}%".format(avg))
# ==================================================================

# https://docs.python.org/3/library/logging.html

"""
To view live log output, run this.
See my ans: https://unix.stackexchange.com/a/687072/114401
        less -N +F ~/cpu_log.log


        #########
        # Print the whole file once to the screen
        cat ~/cpu_log.log

        # Interactively look at the file from the beginning to the end;
        # use `-N` to show line numbers
        less -N ~/cpu_log.log

        # Continually view the most-recent lines in the log file output

        # Option A: with `watch`
        watch -n 1 'tail -n 10 ~/cpu_log.log'

        # Option B [BEST!] with `less`  <========= BEST WAY TO VIEW CONTINUAL OUTPUT ==========
        less -N +F ~/cpu_log.log
        # See: https://unix.stackexchange.com/a/373540/114401
        # This is the same as typing this:
        less -N ~/cpu_log.log
        # ...and then pressing Ctrl + End to have `less` continually load the latest content in the
        # file. Press Ctrl + C to interrupt this behavior and go back to being able to use
        # `less` like normal, scrolling up and down to view data as you desire. Then press
        # q to exit, like normal.
"""


logger = logging.getLogger('my_logger')
logger.setLevel(logging.DEBUG)
log_file_size_bytes = 1024*1024*25  # 25 MB
handler = RotatingFileHandler(str(Path.home()) + '/cpu_log.log', maxBytes=log_file_size_bytes, backupCount=10)
# logger.addHandler(handler)
format = "%(asctime)s, %(levelname)s, %(message)s"  # https://stackoverflow.com/a/56369583/4561887
formatter = logging.Formatter(fmt=format, datefmt='%Y-%m-%d__%H:%M:%S')
handler.setFormatter(formatter)
logger.addHandler(handler)
# logging.basicConfig(
#     handlers=[handler],
#     format=format,
#     datefmt='%Y-%m-%d__%H:%M:%S',
# )


# for _ in range(10000):
#     logger.info('Hello world!')

t_measurement_sec = 4
while True:
    cpu_percent_cores = psutil.cpu_percent(interval=t_measurement_sec, percpu=True)
    avg = sum(cpu_percent_cores)/len(cpu_percent_cores)
    cpu_percent_overall_str = ('%5.2f' % avg) + '%'
    cpu_percent_cores_str = [('%5.2f' % x) + '%' for x in cpu_percent_cores]
    cpu_percent_cores_str = ', '.join(cpu_percent_cores_str)

    logger.info('   ==> Overall: {} <==,    Individual CPUs: {} '.format(
        cpu_percent_overall_str,
        cpu_percent_cores_str))

    # print('Overall: {}'.format(cpu_percent_overall_str))
    # print('Individual CPUs: {}'.format('  '.join(cpu_percent_cores_str)))

    # Popen: https://stackoverflow.com/a/4760517/4561887
    # See: https://unix.stackexchange.com/a/295608/114401
    # cmd = ps -eo %cpu,args | awk '$1 >= 30 {print}'
    cmd = ['ps', '-eo', '%cpu,args']#, '|', 'awk', "'$1 >= 30 {print}'"]
    p = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    out, err = p.communicate()
    # print(out.decode("utf-8"))
    lines = out.decode("utf-8").splitlines()
    # separate out the %cpu usage right at the front from the rest of the ps output
    splitlines = [line.split(maxsplit=1) for line in lines]
    # print(splitlines)

    # filter output to only retain high-cpu processes
    high_cpu_processes_list = []
    for line in splitlines[1:]: # Skip first line since it contains a heading: `%CPU COMMAND`
        individual_cpu_usage_pct = float(line[0])
        cmd = line[1]

        CPU_THRESHOLD_PCT = 15
        if individual_cpu_usage_pct > CPU_THRESHOLD_PCT:
            high_cpu_processes_list.append([('%5.2f' % individual_cpu_usage_pct) + "%", cmd])

    # print(high_cpu_processes_list)
    handler.setFormatter(None) # remove formatter for this log msg only
    high_cpu_processes_list.sort(reverse=True)  # sort highest-cpu-usage first
    for process in high_cpu_processes_list:
        individual_cpu_usage_pct = process[0]
        cmd = process[1]

        logger.info('    {}, cmd: {}'.format(individual_cpu_usage_pct, cmd))
    if not high_cpu_processes_list:
        # logger.info('    No processes are using > {}% of a single CPU.'.format(CPU_THRESHOLD_PCT))
        pass
    handler.setFormatter(formatter)  # restore format for next logs


    # time.sleep(t_measurement_sec)




# print("Measuring CPU load for {} seconds...".format(t_measurement_sec))
# cpu_percent_cores = psutil.cpu_percent(interval=t_measurement_sec, percpu=True)
# avg = sum(cpu_percent_cores)/len(cpu_percent_cores)
# cpu_percent_overall_str = ('%.2f' % avg) + '%'
# cpu_percent_cores_str = [('%.2f' % x) + '%' for x in cpu_percent_cores]
# print('Overall: {}'.format(cpu_percent_overall_str))
# print('Individual CPUs: {}'.format('  '.join(cpu_percent_cores_str)))

