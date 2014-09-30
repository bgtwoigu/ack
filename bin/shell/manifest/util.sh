function x74-df {
git df caf/msm8x74-2163 -- $1
}

function x10-df {
git df caf/msm8x10-190335 -- $1
}

function x74-log {
git l caf/msm8x74-2163
}

function x-dump-log {
git ll caf/LNX.LA.3.5.1_RB1.2 > /tmp/8x74.gl
git ll caf/LNX.LA.3.5.3 > /tmp/8x10.gl
git ll caf/LNX.LA.3.5.3.2 > /tmp/8926.gl
git ll qaep/LNX.LA.3.7_master > /tmp/master.gl
git ll cm/cm-11.0 > /tmp/cm.gl
}

function k-cb-010 {
git f
git cb K-0.1.0 qaep/LNX.LA.3.7_master
git push gs5 K-0.1.0:K-0.1.0
}

function get-xmls {
rm -r gsmanifest
git clone ssh://192.168.180.185:29418/qct/goso/manifest.git gsmanifest
cd gsmanifest
mkdir tmp
brs=(msm8x74 msm8x26 msm8x10 msm8926)
for ((i=0;i<${#brs[@]};i++))
do
    git co origin/${brs[$i]}
    cp *.xml tmp/
done
}

function br {
cat $1 |grep "default remote"
}

function get-local-brs {
touch /tmp/tmp.brs
ls -1 | while read line;
do
    echo $line
    br $line | awk -F '"' '{print $4}' >> /tmp/tmp.brs
done
cat /tmp/tmp.brs | sort | uniq > /tmp/all.brs
rm /tmp/tmp.brs
mv /tmp/all.brs .
}

function get-gs-mod {
rm $2
touch $2.tmp
cat $1 | while read line;
do
   echo $(dirname $line) >> $2.tmp
done
cat $2.tmp | sort | uniq > $2
rm $2.tmp
}

####################### fetch from qaep website ##################
function get-all-br-xml {
rm all.brs
touch all.brs
cat $1 | grep "04\.04\." | awk -F ' ' '{print $6}' | while read line;
do
    echo $line
    br $line | awk -F '"' '{print $4}' >> all.brs
done
cat all.brs | sort | uniq > util/all.br
}

function get-br-xml {
cat util/br.xml | grep $1 | grep "04\.04\." | awk -F ' ' '{print $6}' | while read line;
do
    echo $line
    br $line | awk -F '"' '{print $4}' >> util/$1.brs
done
cat util/$1.brs | sort | uniq > util/$1.br
rm util/$1.brs
}

function get-chip {
cat $1 | grep "04\.04\." | awk -F ' ' '{print $5}' | sort | uniq > util/all.chip
}

function get-chip-br {
cat util/all.chip | while read line;
do
    echo "---------------------"
    echo "get $line:"
    get-br-xml $line
done
}

function find-xml-of-br {
grep -R "default remote" ./LNX.LA.* | grep $1
}
