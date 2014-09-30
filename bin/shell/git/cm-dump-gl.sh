#!/bin/bash

mod=/home/goso/duxd/qctgl/goso.mod

function git-log {
git log --reverse --no-merges 
}

TOP=/code/drv/qaep/cymod/CyanogenMod
DSTTOP=/home/goso/duxd/qctgl

function dump-log {
cat $1 | while read line;
do
src3=$line
src2=${src3#.*}
src1=${src2#\/*}
src0=${src1/platform/android}
src=$TOP/${src0//\//_}.git
dst=$DSTTOP/$line

cd $src
    echo git log $line
    git-log > $dst/cm11.gl
done
}

function main {
dump-log $mod
}

main
