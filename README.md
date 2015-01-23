dotfiles
========

My dotfiles and a script to manage them.

Features
--------
* Sync one, some, or all of your config files with globs.
* `dotfiles.sh` makes backups of local config files if you ever want to revert changes.
* You can use git branches to create configurations for different projects, platforms, etc.

Usage
-----
```
usage: dotfiles.sh [options] [file ... ]

Configuration file manager
Author: Kevin Hanselman | www.github.com/kevlar1818/dotfiles

Arguments:
  file(s)	attempts to link only the glob/file(s)
  		 (defaults to all files matching the glob '_*')

Options:
  -h		show this help text and exit
  -r		remove symlinks and restore backups if present
  -x		all excluding '[file] ...' (ignored if no file args)
  -y		don't ask for confirmation
  -q		quiet mode/suppress output
```

Thanks to
---------
[John Anderson's dotfiles](https://github.com/sontek/dotfiles)

[Mathias Bynens's dotfiles](https://github.com/mathiasbynens/dotfiles)

