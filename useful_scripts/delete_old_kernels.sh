#!/usr/bin/env bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# STATUS: wip; NOT yet functional!

# DESCRIPTION:
# This script automates the deletion of old Linux kernels which are filling up your "/boot"
# partition, as described in this answer here (https://askubuntu.com/a/298986/327339), and
# preventing your auto-updates from working.

# INSTALLATION INSTRUCTIONS:
# 1. Create a symlink in ~/bin to this script so you can run it from anywhere.
#       cd /path/to/here
#       mkdir -p ~/bin
#       ln -si "${PWD}/delete_old_kernels.sh" ~/bin/delete_old_kernels     # required
#       ln -si "${PWD}/delete_old_kernels.sh" ~/bin/gs_delete_old_kernels  # optional; replace "gs" with your initials
# 2. Now you can use this command directly anywhere you like in any of these ways:
#   1. `delete_old_kernels`
#   2. `gs_delete_old_kernels`

# References:
# 1. Not enough free disk space when upgrading - https://askubuntu.com/a/298986/327339
# 1. Where I learned about `sort --key 2`: https://stackoverflow.com/a/6438940/4561887
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/array_practice.sh
# 1. https://github.com/ElectricRCAircraftGuy/eRCaGuy_hello_world/blob/master/bash/array_pass_as_bash_parameter.sh
# 1. ***** https://stackoverflow.com/questions/70572744/how-can-i-create-and-use-a-backup-copy-of-all-input-args-in-bash/70572787#70572787

# save this number of old kernels prior to the current kernel
NUM_PREVIOUS_KERNELS_TO_SAVE="10"

print_boot_partition_size() {
    df -h | grep --color=never -E "^Filesystem|/boot$"
}

boot_size_before="$(print_boot_partition_size)"
echo '"/boot" partition size BEFORE deleting old kernels:'
echo "$boot_size_before"
echo ""

current_linux_kernel="$(uname -r)"
echo "current_linux_kernel = $current_linux_kernel"
echo ""

echo "Linux kernel versions currently installed (active version is highlighted):"
dpkg -l | grep linux-image | sort --key 2 -V | grep -C 99999 --color=always " .*$current_linux_kernel"
echo ""

linux_kernel_list="$(dpkg -l | grep linux-image | sort --key 2 -V | awk '{print $2}')"
# Convert list of strings to array of strings.
# See:
# 1. "eRCaGuy_dotfiles/useful_scripts/find_and_replace.sh" for an example of this
# 1. ***** https://stackoverflow.com/a/24628676/4561887
SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
IFS=$'\n'      # Change IFS (Internal Field Separator) to newline char
linux_kernel_array=($linux_kernel_list) # split long string into array, separating by IFS (newline chars)
IFS=$SAVEIFS   # Restore IFS

i=0
for kernel in "${linux_kernel_array[@]}"; do
    # echo "$kernel" # debugging
    # See: https://stackoverflow.com/a/229606/4561887
    if [[ "$kernel" == *"$current_linux_kernel"* ]]; then
        # echo "$i: $kernel"  # debugging
        break;
    fi
    ((i++))
done
i_last_kernel_to_delete=$((i - NUM_PREVIOUS_KERNELS_TO_SAVE))
echo "i_last_kernel_to_delete = $i_last_kernel_to_delete"  # debugging


echo "Let's delete all kernel versions which are older than $NUM_PREVIOUS_KERNELS_TO_SAVE" \
     "versions prior to the current version ($current_linux_kernel)."
echo "The following old kernels will be deleted. Okay?"

if [ "$i_last_kernel_to_delete" -lt "0" ]; then
    echo "  (NOTHING TO DELETE)"
    echo "Exiting early."
    exit
fi

echo "WARNING: Ensure your current kernel is NOT in this list."
kernels_to_delete=()
for (( i=0; i<"$i_last_kernel_to_delete"; i++ )); do
    kernel="${linux_kernel_array[$i]}"
    kernels_to_delete+=("$kernel")
    echo "    ${kernels_to_delete[i]}"
done

# See: https://stackoverflow.com/a/18546416/4561887
read -p "Continue? (y/N): " confirm
if [[ "$confirm" != [yY] && "$confirm" != [yY][eE][sS] ]]; then
    echo "Exiting early."
    exit
fi

echo "Deleting those old kernels listed above."
# See: https://askubuntu.com/a/298986/327339
# set -x  # turn ON echoing commands; see: https://stackoverflow.com/a/2853811/4561887
# echo "${kernels_to_delete[@]}"  # for debugging (uncomment this and comment out below for debugging)
# sudo apt-get purge "${kernels_to_delete[@]}"  # THE KERNEL DELETE COMMAND
# set +x  # turn OFF echoing commands
echo ""

boot_size_after="$(print_boot_partition_size)"
echo '"/boot" partition size BEFORE deleting old kernels:'
echo "$boot_size_before"
echo ""
echo '"/boot" partition size AFTER deleting old kernels:'
echo "$boot_size_after"

echo ""
echo "Done!"
echo ""



# SAMPLE RUN AND OUTPUT:
#
#       eRCaGuy_dotfiles/useful_scripts$ gs_delete_old_kernels
#       "/boot" partition size BEFORE deleting old kernels:
#       Filesystem                 Size  Used Avail Use% Mounted on
#       /dev/sda2                  705M  586M   68M  90% /boot
#
#       current_linux_kernel = 5.13.0-25-generic
#
#       Linux kernel versions currently installed (active version is highlighted):
#       rc  linux-image-5.4.0-26-generic               5.4.0-26.30                           amd64        Signed kernel image generic
#       rc  linux-image-5.4.0-42-generic               5.4.0-42.46                           amd64        Signed kernel image generic
#       rc  linux-image-5.4.0-45-generic               5.4.0-45.49                           amd64        Signed kernel image generic
#       rc  linux-image-5.4.0-47-generic               5.4.0-47.51                           amd64        Signed kernel image generic
#       rc  linux-image-5.4.0-48-generic               5.4.0-48.52                           amd64        Signed kernel image generic
#       rc  linux-image-5.4.0-51-generic               5.4.0-51.56                           amd64        Signed kernel image generic
#       rc  linux-image-5.4.0-52-generic               5.4.0-52.57                           amd64        Signed kernel image generic
#       rc  linux-image-5.4.0-53-generic               5.4.0-53.59                           amd64        Signed kernel image generic
#       rc  linux-image-5.4.0-54-generic               5.4.0-54.60                           amd64        Signed kernel image generic
#       rc  linux-image-5.4.0-56-generic               5.4.0-56.62                           amd64        Signed kernel image generic
#       rc  linux-image-5.4.0-58-generic               5.4.0-58.64                           amd64        Signed kernel image generic
#       ii  linux-image-5.4.0-59-generic               5.4.0-59.65                           amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-34-generic               5.8.0-34.37~20.04.2                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-36-generic               5.8.0-36.40~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-38-generic               5.8.0-38.43~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-41-generic               5.8.0-41.46~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-43-generic               5.8.0-43.49~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-44-generic               5.8.0-44.50~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-45-generic               5.8.0-45.51~20.04.1+1                 amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-48-generic               5.8.0-48.54~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-49-generic               5.8.0-49.55~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-50-generic               5.8.0-50.56~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-53-generic               5.8.0-53.60~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-55-generic               5.8.0-55.62~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.8.0-59-generic               5.8.0-59.66~20.04.1                   amd64        Signed kernel image generic
#       ii  linux-image-5.8.0-63-generic               5.8.0-63.71~20.04.1                   amd64        Signed kernel image generic
#       rc  linux-image-5.11.0-25-generic              5.11.0-25.27~20.04.1                  amd64        Signed kernel image generic
#       rc  linux-image-5.11.0-27-generic              5.11.0-27.29~20.04.1                  amd64        Signed kernel image generic
#       rc  linux-image-5.11.0-34-generic              5.11.0-34.36~20.04.1                  amd64        Signed kernel image generic
#       rc  linux-image-5.11.0-36-generic              5.11.0-36.40~20.04.1                  amd64        Signed kernel image generic
#       rc  linux-image-5.11.0-37-generic              5.11.0-37.41~20.04.2                  amd64        Signed kernel image generic
#       rc  linux-image-5.11.0-38-generic              5.11.0-38.42~20.04.1                  amd64        Signed kernel image generic
#       rc  linux-image-5.11.0-40-generic              5.11.0-40.44~20.04.2                  amd64        Signed kernel image generic
#       rc  linux-image-5.11.0-41-generic              5.11.0-41.45~20.04.1                  amd64        Signed kernel image generic
#       rc  linux-image-5.11.0-43-generic              5.11.0-43.47~20.04.2                  amd64        Signed kernel image generic
#       rc  linux-image-5.11.0-44-generic              5.11.0-44.48~20.04.2                  amd64        Signed kernel image generic
#       ii  linux-image-5.11.0-46-generic              5.11.0-46.51~20.04.1                  amd64        Signed kernel image generic
#       ii  linux-image-5.13.0-25-generic              5.13.0-25.26~20.04.1                  amd64        Signed kernel image generic
#       ii  linux-image-5.13.0-27-generic              5.13.0-27.29~20.04.1                  amd64        Signed kernel image generic
#       ii  linux-image-5.13.0-28-generic              5.13.0-28.31~20.04.1                  amd64        Signed kernel image generic
#       ii  linux-image-generic-hwe-20.04              5.13.0.28.31~20.04.15                 amd64        Generic Linux kernel image
#
#       Let's delete all kernel versions which are older than 3 versions prior to the current version (5.13.0-25-generic).
#       The following old kernels will be deleted. Okay?
#       WARNING: Ensure your current kernel is NOT in this list.
#           linux-image-5.4.0-26-generic
#           linux-image-5.4.0-42-generic
#           linux-image-5.4.0-45-generic
#           linux-image-5.4.0-47-generic
#           linux-image-5.4.0-48-generic
#           linux-image-5.4.0-51-generic
#           linux-image-5.4.0-52-generic
#           linux-image-5.4.0-53-generic
#           linux-image-5.4.0-54-generic
#           linux-image-5.4.0-56-generic
#           linux-image-5.4.0-58-generic
#           linux-image-5.4.0-59-generic
#           linux-image-5.8.0-34-generic
#           linux-image-5.8.0-36-generic
#           linux-image-5.8.0-38-generic
#           linux-image-5.8.0-41-generic
#           linux-image-5.8.0-43-generic
#           linux-image-5.8.0-44-generic
#           linux-image-5.8.0-45-generic
#           linux-image-5.8.0-48-generic
#           linux-image-5.8.0-49-generic
#           linux-image-5.8.0-50-generic
#           linux-image-5.8.0-53-generic
#           linux-image-5.8.0-55-generic
#           linux-image-5.8.0-59-generic
#           linux-image-5.8.0-63-generic
#           linux-image-5.11.0-25-generic
#           linux-image-5.11.0-27-generic
#           linux-image-5.11.0-34-generic
#           linux-image-5.11.0-36-generic
#           linux-image-5.11.0-37-generic
#           linux-image-5.11.0-38-generic
#           linux-image-5.11.0-40-generic
#           linux-image-5.11.0-41-generic
#       Continue? (y/N): y
#       Deleting those old kernels listed above.
#       [sudo] password for gabriel:
#       Reading package lists... Done
#       Building dependency tree
#       Reading state information... Done
#       The following packages were automatically installed and are no longer required:
#         blender blender-data fonts-cantarell fonts-dejavu gconf2 libart-2.0-2 libblosc1 libbonobo2-0 libbonobo2-common libbonoboui2-0 libbonoboui2-common libdcmtk14 libfprint-2-tod1 libglade2-0 libgnome-2-0
#         libgnome-keyring-common libgnome-keyring0 libgnome2-canvas-perl libgnome2-common libgnome2-gconf-perl libgnome2-perl libgnome2-vfs-perl libgnome2-wnck-perl libgnomecanvas2-0 libgnomecanvas2-common
#         libgnomeui-0 libgnomeui-common libgnomevfs2-0 libgnomevfs2-common libgnomevfs2-extra libgoo-canvas-perl libgoocanvas-common libgoocanvas3 libgtk2-appindicator-perl libgtk2-imageview-perl
#         libgtk2-unique-perl libgtkimageview0 libjemalloc2 libllvm11 libllvm9 libopenimageio2.1 libopenshot-audio6 libopenshot16 libopenvdb6.2 liborbit-2-0 libosdcpu3.4.0 libosdgpu3.4.0 libsass1 libsquish0
#         libunique-1.0-0 libwnck-common libwnck22 linux-modules-5.4.0-59-generic linux-modules-5.8.0-63-generic openshot-qt python3-openshot python3-pyqt5.qtsvg python3-pyqt5.qtwebkit python3-zmq shim
#       Use 'sudo apt autoremove' to remove them.
#       The following packages will be REMOVED:
#         linux-image-5.11.0-25-generic* linux-image-5.11.0-27-generic* linux-image-5.11.0-34-generic* linux-image-5.11.0-36-generic* linux-image-5.11.0-37-generic* linux-image-5.11.0-38-generic*
#         linux-image-5.11.0-40-generic* linux-image-5.11.0-41-generic* linux-image-5.4.0-26-generic* linux-image-5.4.0-42-generic* linux-image-5.4.0-45-generic* linux-image-5.4.0-47-generic*
#         linux-image-5.4.0-48-generic* linux-image-5.4.0-51-generic* linux-image-5.4.0-52-generic* linux-image-5.4.0-53-generic* linux-image-5.4.0-54-generic* linux-image-5.4.0-56-generic*
#         linux-image-5.4.0-58-generic* linux-image-5.4.0-59-generic* linux-image-5.8.0-34-generic* linux-image-5.8.0-36-generic* linux-image-5.8.0-38-generic* linux-image-5.8.0-41-generic*
#         linux-image-5.8.0-43-generic* linux-image-5.8.0-44-generic* linux-image-5.8.0-45-generic* linux-image-5.8.0-48-generic* linux-image-5.8.0-49-generic* linux-image-5.8.0-50-generic*
#         linux-image-5.8.0-53-generic* linux-image-5.8.0-55-generic* linux-image-5.8.0-59-generic* linux-image-5.8.0-63-generic*
#       0 upgraded, 0 newly installed, 34 to remove and 13 not upgraded.
#       After this operation, 21.6 MB disk space will be freed.
#       Do you want to continue? [Y/n] y
#       (Reading database ... 483319 files and directories currently installed.)
#       Removing linux-image-5.4.0-59-generic (5.4.0-59.65) ...
#       /etc/kernel/postrm.d/initramfs-tools:
#       update-initramfs: Deleting /boot/initrd.img-5.4.0-59-generic
#       /etc/kernel/postrm.d/zz-update-grub:
#       Sourcing file `/etc/default/grub'
#       Sourcing file `/etc/default/grub.d/init-select.cfg'
#       Generating grub configuration file ...
#       Found linux image: /boot/vmlinuz-5.13.0-28-generic
#       Found initrd image: /boot/initrd.img-5.13.0-28-generic
#       Found linux image: /boot/vmlinuz-5.13.0-27-generic
#       Found initrd image: /boot/initrd.img-5.13.0-27-generic
#       Found linux image: /boot/vmlinuz-5.13.0-25-generic
#       Found initrd image: /boot/initrd.img-5.13.0-25-generic
#       Found linux image: /boot/vmlinuz-5.11.0-46-generic
#       Found initrd image: /boot/initrd.img-5.11.0-46-generic
#       Found linux image: /boot/vmlinuz-5.8.0-63-generic
#       Found initrd image: /boot/initrd.img-5.8.0-63-generic
#       Adding boot menu entry for UEFI Firmware Settings
#       done
#       Removing linux-image-5.8.0-63-generic (5.8.0-63.71~20.04.1) ...
#       /etc/kernel/prerm.d/dkms:
#       dkms: removing: v4l2loopback 0.12.3 (5.8.0-63-generic) (x86_64)
#
#       -------- Uninstall Beginning --------
#       Module:  v4l2loopback
#       Version: 0.12.3
#       Kernel:  5.8.0-63-generic (x86_64)
#       -------------------------------------
#
#       Status: Before uninstall, this module version was ACTIVE on this kernel.
#
#       v4l2loopback.ko:
#        - Uninstallation
#          - Deleting from: /lib/modules/5.8.0-63-generic/updates/dkms/
#        - Original module
#          - No original module was found for this module on this kernel.
#          - Use the dkms install command to reinstall any previous module version.
#
#       depmod...
#
#       DKMS: uninstall completed.
#       /etc/kernel/postrm.d/initramfs-tools:
#       update-initramfs: Deleting /boot/initrd.img-5.8.0-63-generic
#       /etc/kernel/postrm.d/zz-update-grub:
#       Sourcing file `/etc/default/grub'
#       Sourcing file `/etc/default/grub.d/init-select.cfg'
#       Generating grub configuration file ...
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2439564: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2439564: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2439567: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2439567: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2439570: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2439570: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2439573: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2439573: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2439608: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2439608: /usr/sbin/grub-probe
#       Found linux image: /boot/vmlinuz-5.13.0-28-generic
#       Found initrd image: /boot/initrd.img-5.13.0-28-generic
#       Found linux image: /boot/vmlinuz-5.13.0-27-generic
#       Found initrd image: /boot/initrd.img-5.13.0-27-generic
#       Found linux image: /boot/vmlinuz-5.13.0-25-generic
#       Found initrd image: /boot/initrd.img-5.13.0-25-generic
#       Found linux image: /boot/vmlinuz-5.11.0-46-generic
#       Found initrd image: /boot/initrd.img-5.11.0-46-generic
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2440268: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on vgs invocation. Parent PID 2440268: /usr/sbin/grub-probe
#       File descriptor 10 (/var/lib/dpkg/triggers/linux-update-5.4.0-59-generic (deleted)) leaked on lvs invocation. Parent PID 2440425: /bin/sh
#       Adding boot menu entry for UEFI Firmware Settings
#       done
#       (Reading database ... 483311 files and directories currently installed.)
#       Purging configuration files for linux-image-5.8.0-53-generic (5.8.0-53.60~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.8.0-53-generic': Directory not empty
#       Purging configuration files for linux-image-5.8.0-45-generic (5.8.0-45.51~20.04.1+1) ...
#       Purging configuration files for linux-image-5.8.0-41-generic (5.8.0-41.46~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.8.0-41-generic': Directory not empty
#       Purging configuration files for linux-image-5.8.0-43-generic (5.8.0-43.49~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.8.0-43-generic': Directory not empty
#       Purging configuration files for linux-image-5.4.0-26-generic (5.4.0-26.30) ...
#       Purging configuration files for linux-image-5.4.0-53-generic (5.4.0-53.59) ...
#       rmdir: failed to remove '/lib/modules/5.4.0-53-generic': Directory not empty
#       Purging configuration files for linux-image-5.11.0-38-generic (5.11.0-38.42~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.11.0-38-generic': Directory not empty
#       Purging configuration files for linux-image-5.8.0-48-generic (5.8.0-48.54~20.04.1) ...
#       Purging configuration files for linux-image-5.11.0-37-generic (5.11.0-37.41~20.04.2) ...
#       rmdir: failed to remove '/lib/modules/5.11.0-37-generic': Directory not empty
#       Purging configuration files for linux-image-5.8.0-34-generic (5.8.0-34.37~20.04.2) ...
#       Purging configuration files for linux-image-5.11.0-41-generic (5.11.0-41.45~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.11.0-41-generic': Directory not empty
#       Purging configuration files for linux-image-5.11.0-25-generic (5.11.0-25.27~20.04.1) ...
#       Purging configuration files for linux-image-5.4.0-58-generic (5.4.0-58.64) ...
#       rmdir: failed to remove '/lib/modules/5.4.0-58-generic': Directory not empty
#       Purging configuration files for linux-image-5.4.0-56-generic (5.4.0-56.62) ...
#       Purging configuration files for linux-image-5.8.0-55-generic (5.8.0-55.62~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.8.0-55-generic': Directory not empty
#       Purging configuration files for linux-image-5.4.0-52-generic (5.4.0-52.57) ...
#       rmdir: failed to remove '/lib/modules/5.4.0-52-generic': Directory not empty
#       Purging configuration files for linux-image-5.4.0-51-generic (5.4.0-51.56) ...
#       Purging configuration files for linux-image-5.8.0-49-generic (5.8.0-49.55~20.04.1) ...
#       Purging configuration files for linux-image-5.11.0-27-generic (5.11.0-27.29~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.11.0-27-generic': Directory not empty
#       Purging configuration files for linux-image-5.8.0-63-generic (5.8.0-63.71~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.8.0-63-generic': Directory not empty
#       Purging configuration files for linux-image-5.11.0-34-generic (5.11.0-34.36~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.11.0-34-generic': Directory not empty
#       Purging configuration files for linux-image-5.4.0-47-generic (5.4.0-47.51) ...
#       Purging configuration files for linux-image-5.4.0-48-generic (5.4.0-48.52) ...
#       rmdir: failed to remove '/lib/modules/5.4.0-48-generic': Directory not empty
#       Purging configuration files for linux-image-5.8.0-38-generic (5.8.0-38.43~20.04.1) ...
#       Purging configuration files for linux-image-5.11.0-36-generic (5.11.0-36.40~20.04.1) ...
#       Purging configuration files for linux-image-5.8.0-44-generic (5.8.0-44.50~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.8.0-44-generic': Directory not empty
#       Purging configuration files for linux-image-5.8.0-50-generic (5.8.0-50.56~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.8.0-50-generic': Directory not empty
#       Purging configuration files for linux-image-5.4.0-45-generic (5.4.0-45.49) ...
#       Purging configuration files for linux-image-5.11.0-40-generic (5.11.0-40.44~20.04.2) ...
#       rmdir: failed to remove '/lib/modules/5.11.0-40-generic': Directory not empty
#       Purging configuration files for linux-image-5.4.0-42-generic (5.4.0-42.46) ...
#       Purging configuration files for linux-image-5.8.0-59-generic (5.8.0-59.66~20.04.1) ...
#       rmdir: failed to remove '/lib/modules/5.8.0-59-generic': Directory not empty
#       Purging configuration files for linux-image-5.4.0-59-generic (5.4.0-59.65) ...
#       rmdir: failed to remove '/lib/modules/5.4.0-59-generic': Directory not empty
#       Purging configuration files for linux-image-5.4.0-54-generic (5.4.0-54.60) ...
#       rmdir: failed to remove '/lib/modules/5.4.0-54-generic': Directory not empty
#       Purging configuration files for linux-image-5.8.0-36-generic (5.8.0-36.40~20.04.1) ...
#
#       "/boot" partition size BEFORE deleting old kernels:
#       Filesystem                 Size  Used Avail Use% Mounted on
#       /dev/sda2                  705M  586M   68M  90% /boot
#
#       "/boot" partition size AFTER deleting old kernels:
#       Filesystem                 Size  Used Avail Use% Mounted on
#       /dev/sda2                  705M  484M  170M  74% /boot
#
#       Done!
#
