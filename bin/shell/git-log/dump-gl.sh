#!/bin/bash

brs=/home/git/bin/all.brs
src=`pwd`
dst2=${src/\/code\/gb\/qct/\/tmp\/qctgl}
dst=${dst2%.*}

#echo $src
echo $dst
#echo $brs

function git-log {
git log --reverse --no-merges $1
}

function dump-log {
rm $2/*.gl
cat $1 | while read line;
do
    #echo git log $line
    git-log $line > $dst/$line.gl
done
}

function main {
mkdir -p $dst
dump-log $brs $dst
}

main
