This is a folder to test the `find_and_replace.sh` script (aliased as `gs_find_and_replace` in my case). 

Use this command to test the script. 

Description: find any filename in path "useful_scripts/find_and_replace_test_folder" which ends in ".cpp" or ".txt", and replace all occurences of "bo" with "do":

    gs_find_and_replace "useful_scripts/find_and_replace_test_folder" "(\.cpp$|\.txt$)" "bo" "do"

