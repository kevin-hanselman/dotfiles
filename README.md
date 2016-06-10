dotfiles
========

My dotfiles and a script to manage them.

Overview
--------
`dotfiles.sh` was written to act much like [GNU Stow](https://www.gnu.org/software/stow/stow.html), only with dotfiles in mind from the start. The main differences are:
* `dotfiles.sh` always targets the user's home directory (i.e. `stow -t $HOME`).
* `dotfiles.sh` never symlinks directories, only files (i.e. ` stow --no-folding`).
* `dotfiles.sh` makes backups of local config files and restores them if you ever remove your symlinked version.

Usage
-----
```
usage: dotfiles.sh [options] [subdirectory ... ]

Configuration file manager | github.com/kevlar1818/dotfiles

Copyright 2014-2016 Kevin Hanselman (See LICENSE or source)

Arguments:
  subdirectory    symlinks all files in the given subdirectory
                  (defaults to all subdirectories)

Options:
  -r              remove symlinks and restore backups if present
  -n              show what would be done, but take no other action
  -h              show this help text and exit
```

For example, to install vim and bash RCs:

```
./dotfiles.sh vim bash
```


