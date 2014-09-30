#!/bin/bash

mod=/home/goso/duxd/qctgl/goso.mod

function git-log {
git log --reverse --no-merges LNX.LA.3.7_master
}

TOP=/code/drv/qaep/gaep
DSTTOP=/home/goso/duxd/qctgl

function dump-log {
cat $1 | while read line;
do
src3=$line
src=$TOP/$src3.git
dst=$DSTTOP/$line

cd $src
    echo git log $line
    git-log > $dst/master37.gl
done
}

function main {
dump-log $mod
}

main
