#!/bin/bash

mod=/home/goso/duxd/qctgl/m371.mod

function git-log {
git log --reverse --no-merges LNX.LA.3.7.1_master
}

TOP=/code/drv/qaep/qct
DSTTOP=/home/goso/duxd/qctgl

function dump-log {
cat $1 | while read line;
do
src3=$line
src=$TOP/$src3.git
dst=$DSTTOP/$line
mkdir -p $dst
cd $src
    echo git log $line
    git-log > $dst/master371.gl
done
}

function main {
dump-log $mod
}

main
