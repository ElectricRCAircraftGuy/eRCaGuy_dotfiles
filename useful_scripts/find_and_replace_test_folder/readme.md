This is a folder to test the `find_and_replace.sh` script. 

References:

1. 

Use this command to test the script. 

Description: find any filename in path "useful_scripts/find_and_replace_test_folder" which is NOT "readme.md", "Readme.md", or "README.md", and replace all occurences of "bo" with "do":

    gs_find_and_replace "useful_scripts/find_and_replace_test_folder" "^/(?!readme\.md|Readme\.md|README\.md)(.*)$" "bo" "do"