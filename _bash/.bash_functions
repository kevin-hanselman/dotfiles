#! /bin/bash
#
# Functions
#

cl()
{
	cd $1; clear; ls
}

cltest()
{
    RET="`cd $1`"
    if [ "$RET" ]; then
        echo "cd returned: \"$RET\""
    else
        cd $1; ls
    fi
}

shparproc()
{
	cat /proc/$PPID/status | head -1 | cut -f2
}

# change extensions for all files in the current directory
# $1 = extension to be changed
# $2 = new extension
# NOTE: must include '.' in both $1 and $2
chext()
{
    for f in *$1; do
        name=`echo $f | cut -d . -f 1`
        new=$name$2
        mv $f $new
    done
}
