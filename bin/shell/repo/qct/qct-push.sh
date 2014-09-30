#!/bin/sh
#msm8x10-190335
#gjb_193503a_v002
#msm8x10-190330-orig
#msm8x10-193512a
#gjb_1930_v001

BR=gjb_193503a_v002
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
