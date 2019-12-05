dotfiles
========

My dotfiles and a script to manage them.

Overview
--------
`dotfiles.sh` was written to act much like [GNU Stow](https://www.gnu.org/software/stow/stow.html),
only with dotfiles in mind from the start. The main differences are:

* `dotfiles.sh` targets the user's home directory by default (i.e. `stow -t $HOME`).
* `dotfiles.sh` never symlinks directories, only files (i.e. ` stow --no-folding`).
* `dotfiles.sh` makes backups of local config files and can restore them if you remove your symlinked version.

Usage
-----
```
usage: dotfiles.sh [options] <subdirectory ... >

Configuration file manager | github.com/kevlar1818/dotfiles

Copyright 2014-2020 Kevin Hanselman (See LICENSE or source)

Arguments:
  subdirectory    symlinks all files in the given subdirectory

Options:
  -n              show what would be done, but take no other action
  -r              remove symlinks and restore backups if present
  -C              copy files rather than using symlinks
  -t TARGET       use TARGET as the base target directory
                  (defaults to $HOME)
  -h              show this help text and exit
```

For example, to install dotfiles for vim and bash:

```
./dotfiles.sh vim bash
```
