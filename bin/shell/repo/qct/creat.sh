#!/bin/sh

TOP=`pwd`
cat $1 | while read line;
do
	mkdir -p $TOP/$line
	pwd
	cd $TOP/$line
	git init --bare
done

cd $TOP
