This file is part of eRCaGuy_dotfiles: https://github.com/ElectricRCAircraftGuy/eRCaGuy_dotfiles


Copy the contents of this `Templates/` dir to `~/Templates/`. Any files inside the `~/Templates/` dir automatically get added to the file manager's right-click --> "Create New Document" menu.

Adding symlinks is also acceptable. Then, when the right-click --> "Create New Document" menu is used, the symlinks will be followed and the files _they point to_ will be copied to the new location, which is what we want!

To add symlinks, run the provided installer:
```bash
./INSTALL.sh
```
