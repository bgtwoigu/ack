#!/bin/sh

BR=msm8x10-190335
OLD=/code/gb/qct
TOP=`pwd`
cat $1 | while read line;
do
	cd $OLD/$line
	pwd
	echo git push $TOP/$line $BR:$BR
	git push $TOP/$line $BR:$BR
done

cd $TOP
