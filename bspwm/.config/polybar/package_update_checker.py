#!/usr/bin/env python
import sys
from subprocess import run


def colorize_text(text, color):
    return f'%{{F{color}}}{text}%{{F-}}'


if __name__ == '__main__':
    xrdb = run('xrdb -query', shell=True, capture_output=True, text=True, check=True)

    raw_colors = (
        line.replace('*', '').split(':')
        for line in xrdb.stdout.split('\n')
        if line.startswith('*')
    )

    x_colors = {
        name: color.strip()
        for name, color in raw_colors
    }

    checkupdates = run('checkupdates', capture_output=True, text=True)

    # checkupdates returns non-zero with no output if there's no packages to
    # upgrade
    if checkupdates.returncode != 0 and checkupdates.stderr:
        print(colorize_text('ERR', x_colors['color1']))
        sys.exit(0)

    stripped_lines = (
        line.strip()
        for line in checkupdates.stdout.split('\n')
    )
    packages = [
        line.split(' ')[0]
        for line in stripped_lines
        if line
    ]

    if 'linux' in packages:
        color = x_colors['color3']

    elif packages:
        color = x_colors['foreground']

    else:
        color = x_colors['color8']

    print(colorize_text(len(packages), color))
