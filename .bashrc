# Some nice nuggest to put in the bottom of your "~/.bashrc" file!

# GS: show shell level and git branch
# See: https://stackoverflow.com/questions/4511407/how-do-i-know-if-im-running-a-nested-shell/57665918#57665918
git_show_branch() {
    __gsb_BRANCH=$(git symbolic-ref -q --short HEAD 2>/dev/null)
    if [ -n "$__gsb_BRANCH" ]; then
        echo "$__gsb_BRANCH"
    fi
}
export PS1="\e[7m\$(git_show_branch)\e[m\n\h \w $ "
export PS1='\$SHLVL'":$SHLVL $PS1"

# GS: git branch backups: back up git branch hashes
gs_git_branch_hash_bak () {
    DATE=`date +%Y%m%d-%H%Mhrs-%Ssec`
    FILE="./git_branch_hash_backups/git_branch_bak--${DATE}.txt"
    BRANCH="$(git_show_branch)"
    DIR=$(pwd)
    echo -e "pwd = \"$DIR\"" > $FILE
    echo -e "current branch name = \"$BRANCH\"" >> $FILE
    echo -e "\n=== \`git branch -vv\` ===\n" >> $FILE
    git branch -vv >> $FILE
}
alias gs_git_branch_hash_bak_echo='echo "this is a bash function in ~/.bashrc which backs up to ./git_branch_hash_backups"'
# alias gs_git_branch_hash_bak_ls='ls /home/gabriels/GS/dev/av_GS_bak/branch_names_and_hashes/'
# alias gs_git_branch_hash_bak_ls_echo='echo ls /home/gabriels/GS/dev/av_GS_bak/branch_names_and_hashes/'
# alias gs_git_branch_hash_bak_nemo='nemo /home/gabriels/GS/dev/av_GS_bak/branch_names_and_hashes/'
# alias gs_git_branch_hash_bak_nemo_echo='echo nemo /home/gabriels/GS/dev/av_GS_bak/branch_names_and_hashes/'



