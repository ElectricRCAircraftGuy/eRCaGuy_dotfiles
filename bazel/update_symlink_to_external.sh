#!/bin/bash

# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles
#
# DESCRIPTION:
#
# In your Bazel project, external, auto-downloaded dependencies (other repos and libraries and
# things) will be located in this dir here: "$(bazel info output_base)/external", where the cmd
# `bazel info output_base` will call bazel to have it output the path to that cached dir. But, that
# dir can potentially change when you build (since the dir name is some funky cache hash or
# something that bazel makes).
#
# So, this script will create or update a local symlink to that "external" dir so you and your IDE
# can always index and browse files in it through the symlink at this known, fixed path, rather than
# through the potentially-changing bazel cache path.
#
#
# INSTALLATION & USAGE INSTRUCTIONS:
# 1. Copy this file into the root dir of a project where you are using `bazel` as your build system.
#       cp update_symlink_to_external.sh "path/to/some/bazel_project"
# 2. Ensure it is executable:
#       chmod +x "path/to/some/bazel_project/update_symlink_to_external.sh"
# 3. Run it:
#       "path/to/some/bazel_project/update_symlink_to_external.sh"
#       # OR, if you are already in that dir:
#       ./update_symlink_to_external.sh
# 4. Now, you may search the newly-created, or updated symlinked "external" directory here:
#    "path/to/some/bazel_project/external". Look at external code and libraries therein.
# 5. To update this symlinked "external" directory again, in case the bazel cache path changes,
#    simply run the script again.

RETURN_CODE_SUCCESS=0
RETURN_CODE_ERROR=1


FULL_PATH_TO_SCRIPT="$(realpath "$0")"
SCRIPT_DIRECTORY="$(dirname "$FULL_PATH_TO_SCRIPT")"

target_dir="$(bazel info output_base)/external"

ret_code="$?"
if [ "$ret_code" -ne "$RETURN_CODE_SUCCESS" ]; then
    echo "ERROR: Failed to run Bazel and get path to Bazel \"output_base/external\" dir. Please "
    echo "cd into a valid project where you are using Bazel as your build system, and try again."
    exit $ret_code
fi

echo "Creating symlink to dir \"$target_dir\" inside \"$SCRIPT_DIRECTORY\"."
ln -sfi "$target_dir" "$SCRIPT_DIRECTORY"
