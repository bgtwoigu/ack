
function lang_find_values()
{
  local lfolder
  local lfname
  if [ "$1" = "en" ] ; then
    lfolder=values
  else
    lfolder=values-$1
  fi

  lfname=$LANG_WORK_DIR/$1/vflist

  local lvroot=$(dirname $lfname)
  mkdir -p $lvroot

  pushd $ANDROID_ROOT
  echo "pls wait..."
  find . -name "$lfolder" > $lfname
  popd

  head -n 3 $lfname
  echo "skiped ..."
  tail -n 3 $lfname

  pushd $lvroot
  cat $lfname | while read line
  do
    local lfcpsrc=$ANDROID_ROOT/$line/strings.xml
    if [ -f $lfcpsrc ] ; then
      mkdir -p $line
      cp -v $lfcpsrc $line
    fi
  done
  popd
}

function lang_remove_untranslate()
{
  find $LANG_WORK_DIR/$1/ -name "*\.xml" -exec sed -i "/translatable=\"false\"/d" {} \;
}

function lang_copy_strings()
{
  local lc
  if [ -z $1 ] ; then
    lc=en
  else
    lc=$1
  fi
  lang_find_values $lc
#  lang_remove_untranslate $lc
}

function lang_rm_work_dir()
{
  LANG_WORK_DIR=
  rm -rf $LANG_ROOT/2014*
}

function lang_strings_xml2csv()
{
  local R3=$RED_ROOT/r3
  local xml2csv=$RED_ROOT/xml2csv.r
  local lfname=$LANG_WORK_DIR/$1/vflist

  cat $lfname | while read line
  do
    local lfsrc=$LANG_WORK_DIR/$1/$line/strings.xml
    if [ -f $lfsrc ] ; then
      $R3 $xml2csv $lfsrc
    fi
  done

}

function lang_gen_diff()
{
  local lfname=$LANG_WORK_DIR/$1/vflist

  rm -rf $LANG_WORK_DIR/en-$1
  cp -r $LANG_WORK_DIR/en/ $LANG_WORK_DIR/en-$1

  cat $lfname | while read line
  do
    local lfsrc=$LANG_WORK_DIR/$1/$line/strings.csv
    local lfdest=$line/strings.csv
    lfdest=`echo $lfdest | sed "s/-$1//"`
    lfdest=$LANG_WORK_DIR/en-$1/$lfdest
    echo $lfdest
    if [ -f $lfsrc ] ; then
      echo $lfsrc
      for item in `cat $lfsrc | cut -d '|' -f 1`
      do
        sed -i "/$item/d" $lfdest
      done
    fi
  done
}

function lang_clean()
{
  for dir in cts device gdk sdk hardware external
  do
    rm -rf $LANG_WORK_DIR/en-$1/$dir
  done

  find $LANG_WORK_DIR/en-$1/ -type f -size 0 -exec rm -f {} \;
  find $LANG_WORK_DIR/en-$1/ -name "*test*" -exec rm -rf {} \;
}

function lang_merge()
{
  local lfmerge=$LANG_WORK_DIR/en-$1/all-en-$1.csv
  rm -f $lfmerge
  local lfcsv=`find $LANG_WORK_DIR/en-$1/ -name "*\.csv"`

  echo "key|en-string|$1-string" > $lfmerge
  for f in $lfcsv
  do
    echo "path|$f" >> $lfmerge
    cat $f >> $lfmerge
  done

  mv $lfmerge $lfmerge.bak
  grep "|" $lfmerge.bak > $lfmerge

  head -n 3 $lfmerge
  echo "skiped ..."
  tail -n 3 $lfmerge

}
