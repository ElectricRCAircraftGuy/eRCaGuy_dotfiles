#!/usr/bin/env python3

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# STATUS: WORKS! TODO: UPDATE THE COMMENTS below and clean up the code.

# Print out basic stats on cpu load.

# INSTALLATION INSTRUCTIONS:##### UPDATE THESE! ####
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere.
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/cpu_load.py" ~/bin/cpu_load            # required
#       ln -si "${PWD}/cpu_load.py" ~/bin/gs_cpu_load         # optional; replace "gs" with your initials
# 2. Now you can use this command directly anywhere you like in any of these ways:
#   1. `cpu_load`
#   2. `gs_cpu_load`

# References:
# 1. [my answer] https://askubuntu.com/a/1423003/327339

# Sample run and output:
#       $ gs_cpu_load
#       Measuring CPU load for 2 seconds...
#       Overall: 15.21%
#       Individual CPUs: 13.60%  12.20%  15.20%  14.90%  14.60%  18.50%  15.80%  16.90%



##### https://unix.stackexchange.com/a/295608/114401   <========

import psutil

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

t_measurement_sec = 2
print("Measuring CPU load for {} seconds...".format(t_measurement_sec))
cpu_percent_cores = psutil.cpu_percent(interval=t_measurement_sec, percpu=True)
avg = sum(cpu_percent_cores)/len(cpu_percent_cores)
cpu_percent_overall_str = ('%.2f' % avg) + '%'
cpu_percent_cores_str = [('%.2f' % x) + '%' for x in cpu_percent_cores]
print('Overall: {}'.format(cpu_percent_overall_str))
print('Individual CPUs: {}'.format('  '.join(cpu_percent_cores_str)))

