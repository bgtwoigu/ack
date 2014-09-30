function cls-change-id {
rm -f *.gl
rm -f *.chid
rm -f *.diff
rm -f *.all
rm -f chid.base
cp /tmp/*.gl .
}

function gl2chid {
grep "^ *Change-Id:" $1 | awk -F ':' '{print $2}' | sed 's/^[ ]*//' | grep -v Change-Id | sort | uniq > $1.chid
}

function get-change-id {
rm -f *.chid
ls -1 *.gl | while read line;
do
    echo grep Change-Id $line
    gl2chid $line
    #grep "^ *Change-Id:" $line | awk -F ':' '{print $2}' | sed 's/^[ ]*//' | grep -v Change-Id | sort | uniq > $line.chid
done
}

function mod_chid {
TOP=`pwd`
cat goso.mod | while read line;
do
    cd $TOP/$line
    echo
    echo -n "$line"
    gl2chid $1
    gl2chid $2
    rm-diff $1.chid $2.chid
    all_chid2commit $1.chid.diff
    mv $1.chid.diff.gl $1.all
    chid=`cat $1.chid.diff | wc -l`
    echo -n ":chid:$chid"
    unset chid
done
cd $TOP
cp_gl $3
$3_gl2cif
}

function sed-rm-diff {
cat chid.base | while read line;
do
    sed -i "/$line/d" $1
done
cat $1 | sort | uniq > $1.diff.all
}

function rm-diff {
    diff $1 $2 | grep "^<" | sed 's/^< //' > $1.diff
    ci=`cat $1.diff | wc -l`
    echo -n ":ci:$ci"
    unset ci
}

function diff-change-id {
ls -1 *.chid | while read line;
do
    echo -n "get diff $line:"
    rm-diff $line chid.base
    echo
done
}

function all-diff {
get-change-id
rm -f *.diff
rm -f *.all
ls -1 *.chid | while read line;
do
    echo "-------------------"
    echo usebase: $line
    cp $line chid.base
    diff-change-id
    echo
    cat *.diff | sort | uniq > $line.diff.all
    echo -n "all diff with $line:"
    cat $line.diff.all | wc -l
done
}
function all-diff-res {
awk 'NR==127{print}' res.txt
awk 'NR==157{print}' res.txt
awk 'NR==137{print}' res.txt
awk 'NR==168{print}' res.txt
awk 'NR==143{print}' res.txt
awk 'NR==174{print}' res.txt
awk 'NR==149{print}' res.txt
awk 'NR==180{print}' res.txt
}

function _chid2commit {
grep -m 1 -A 0 -B $1 $2 $3
}

function _email2commit {
grep -B 1 -A $1 $2 $3
}

function _email2commit_goso {
grep -h -R -B 1 -A 0 "^Author.*gosomo" *.gl
}

function _email2commit_ice {
grep -h -R -B 1 -A 0 "^Author.*ceberg" *.gl
}

function email2commit {
rm -f all.ci
touch all.ci
_email2commit_ice >> all.ci
_email2commit_goso >> all.ci
grep "^commit" all.ci | awk -F ' ' '{print $2}' | sort | uniq > all.ci2
mv all.ci2 all.ci
ci=`cat all.ci | wc -l`
echo -n ":ci:$ci"
unset ci
}

function _commit2gitlog {
grep -h -R -B 0 -A $1 $2 *.gl
}

function commit2gitlog {
for((i=5;i<=999;i++));
do
    mat=`_commit2gitlog $i $1 | tail -c 53 | head -c 9`
    if [ "x$mat" == "xChange-Id" ]; then
        _commit2gitlog $i $1
        break
    fi
done
}

function mod_commit2gitlog {
rm -f master.gl
email2commit
rm -f gl.all
touch gl.all
cat all.ci | while read line;
do
    commit2gitlog $line >> gl.all
done
gl2chid gl.all
cp gl.all master.gl
all_chid2commit gl.all.chid
rm -f master.gl
mv gl.all.chid.gl goso.gl.all
chid=`cat gl.all.chid | wc -l`
echo -n ":chid:$chid"
unset chid
}

function _chid2commit_master {
grep -h -R -m 1 -A 0 -B $1 $2 master37.gl cm11.gl msm8926-21241.gl msm8926-21234.gl msm8x74-2163.gl msm8x10-190335.gl msm8x10-190330-orig.gl msm8926-2130.gl msm8926-21238.gl msm8926-2131.gl msm8926-2126.gl msm8x74-2145.gl msm8x10-190330.gl msm8x10-193512a.gl gjb_193503a_v002.gl msm8x26-1634-orig.gl msm8926-1130009.gl msm8926-1130002.gl msm8926-1130012-smartfren.gl msm8x26-1634.gl  msm8926-1130011.gl msm8926-110207.gl msm8926-1130012.gl msm8x10-193506a.gl msm8926-1130005.gl gjb_1930_v001.gl
}

function chid2commit {
for((i=5;i<=999;i++));
do
    mat=`_chid2commit_master $i $1 | head -c 6`
    if [ "x$mat" == "xcommit" ]; then
        _chid2commit_master $i $1 | grep -m 1 -A 0 -B $i $1
        break
    fi
done
}

function all_chid2commit {
rm -f $1.gl
touch $1.gl
cat $1 | while read line;
do
    chid2commit $line >> $1.gl
done
}

function gen_mod {
#grep -B 0 -A 4 "^commit" $1 > $1.mod
#sed -i '/^commit\|^Author\|^Date\|^--\|^\s*$/d' $1.mod
#cat $1.mod | awk -F ':' '{print $1}' | sed 's/^[ ]*//' | sort | uniq > $line.chid
grep -B 0 -A 4 "^commit" $1 | sed '/^commit\|^Author\|^Date\|^--\|^\s*$/d' | awk -F ':' '{print $1}' | sed 's/^[ ]*//' | sort | uniq > $1.mod
}

function _all_mod {
TOP=`pwd`

cat $1 | while read line;
do
    cd $line
    echo
    echo -n "$line"
    mod_commit2gitlog
    cd - > /dev/null
done
}

function cp_gl {
    _cp_gl out_$1 $1.gl.all $1
}
function _cp_gl {
rm -rf $1
mkdir $1
TOP=`pwd`
cat goso.mod | while read line;
do
    src=$TOP/$line/$2
    dst2=${line//\//\%}.gl
    dst3=${dst2#.*}
    dst=${dst3#\%*}
    cp $src $1/$dst
done
}

function goso_gl2cif {
    _gl2cif goso qct
}
function master37_gl2cif {
    _gl2cif master37 gaep
}
function _gl2cif {
cd out_$1
ls -1 *.gl | while read line;
do
    ci2file_$2 $line
done
cd ..
}

function ci2file_qct {
    ci2file $1 /code/gb/qct
}
function ci2file_gaep {
    ci2file $1 /code/drv/qaep/gaep
}
function ci2file_cm {
    ci2file $1 /code/gb/qct
}

function cionly2file {
rm -f $1.f
touch $1.f
rm -f $1.fo
touch $1.ff
cat $1 | while read line;
do
    git --git-dir=$2 show --name-only $line >> $1.f
    git --git-dir=$2 show --name-only --oneline $line | sed '1d' >> $1.ff
done

cat $1.ff | sort | uniq > $1.fo
rm -f $1.ff
}

function ci2file {
rm -f $1.f
touch $1.f
rm -f $1.fo
touch $1.ff
p=$1
p3=${p%.*}
p2=${p3//\%/\/}.git
grep "^commit" $1 | awk -F ' ' '{print $2}' | while read line;
do
    git --git-dir=$2/$p2 show --name-only $line >> $1.f
    git --git-dir=$2/$p2 show --name-only --oneline $line | sed '1d' >> $1.ff
done

cat $1.ff | sort | uniq > $1.fo
rm -f $1.ff
}

function master37_mod {
    mod_chid master37.gl msm8x74-2163.gl master37| tee $1
}
function cm_mod {
    mod_chid cm11.gl msm8x74-2163.gl cm11 | tee $1
}

function all_mod {
_all_mod goso.mod | tee $1
cp_gl goso
}

function test_cif {
cd out_$1
ls -1 *.gl | while read line;
do
    echo
    echo -n "$line"
    grep "^commit" $line | awk -F ' ' '{print $2}' | sort > $line.ci.old 
    grep "^commit" $line.f | awk -F ' ' '{print $2}' | sort > $line.ci.new
    rm-diff $line.ci.old $line.ci.new
    mv $line.ci.old.diff $line.diff
    rm $line.ci.old $line.ci.new
done
cd ..
}

function master37_test {
    test_cif master37 | tee $1
}

function m371_test {
TOP=`pwd`
cat m371.mod | while read line;
do
    cd $TOP/$line
    echo "$line"
    all-diff > res.txt
    all-diff-res
done
cd $TOP
}
