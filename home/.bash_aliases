
# TODO: move all of my custom aliases from ~/.bashrc to here instead
# Also, get rid of all "_echo" type commands, since it turns out you can just type `alias myalias` instead to see
# what its full command is! Document that in this file and in ~/.bashrc too.

# See: [my own ans] https://askubuntu.com/questions/791002/how-to-prevent-sshfs-mount-freeze-after-changing-connection-after-suspend/942820#942820
alias gs_sshfs_myserver="sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 \
username@server_hostname:/path/on/server/to/mount ~/mnt/my_server"

