# This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles

# This is a configuration file which accompanies the script
# named "eRCaGuy_dotfiles/useful_scripts/sublf.sh".

# Append any arguments to this array which you'd like to pass to the underlying `find` command used
# in `eRCaGuy_dotfiles/useful_scripts/sublf.sh`! This is especially useful to exclude certain
# folders in the search path.
#
# For the most-correct `find -not`... syntax, see:
#   1. https://stackoverflow.com/a/16595367/4561887
#   2. and my answer here: https://stackoverflow.com/a/69830768/4561887

additional_find_args_or_excludes=()  # create array

# Append your custom arguments

# additional_find_args_or_excludes+=(-not \( -path "*/.git/*" -prune \))
# additional_find_args_or_excludes+=(-not \( -path "./build/*" -prune \))
# additional_find_args_or_excludes+=(-not \( -path "./output*" -prune \))
# additional_find_args_or_excludes+=(-not \( -path "*/some/other/dir_to_exclude/*" -prune \))
