#!/bin/sh
#msm8x10-190335
#gjb_193503a_v002
#msm8x10-190330-orig
#msm8x10-193512a
#gjb_1930_v001

BR=LNX.LA.3.7_master
BR1=LNX.LA.3.7.1_master
OLD=/code/drv/qaep/qct
TOP=`pwd`
cat $1 | while read line;
do
	cd $OLD/$line
	pwd
	echo git push $TOP/$line $BR:$BR
	git push $TOP/$line $BR:$BR
	git push $TOP/$line $BR1:$BR1
done

cd $TOP
