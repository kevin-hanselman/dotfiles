dotfiles
========

My dotfiles and a script to manage them.

Features
--------
* Sync one, some, or all of your config files with globs.
* `dotfiles.sh` makes backups of local config files if you ever want to revert changes.

Usage
-----
```
usage: dotfiles.sh [options] [file ... ]

Configuration file manager | www.github.com/kevlar1818/dotfiles

Copyright 2015 Kevin Hanselman (See LICENSE or source)

Arguments:
  file(s)         attempts to link only the glob/file(s)
                  (defaults to all files matching the glob '_*')

Options:
  -h              show this help text and exit
  -r              remove symlinks and restore backups if present
  -x              act on all files excluding '[file] ...'
  -q              quiet mode/suppress output
```

Thanks to
---------
[John Anderson's dotfiles](https://github.com/sontek/dotfiles)

[Mathias Bynens's dotfiles](https://github.com/mathiasbynens/dotfiles)

