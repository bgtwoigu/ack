#!/bin/sh
#msm8x10-190335
#gjb_193503a_v002
#msm8x10-190330-orig
#msm8x10-193512a
#gjb_1930_v001
#BR=gjb_193503a_v002

OLD=/code/ics
TOP=`pwd`
cat $1 | while read line;
do
	cat $2 | while read BR;
	do
		cd $OLD/$line
		pwd
		echo git push $TOP/$line $BR:$BR
		git push -f $TOP/$line $BR:$BR
	done
done

cd $TOP
