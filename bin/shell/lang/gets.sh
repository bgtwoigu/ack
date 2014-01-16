
function lang_find_values()
{
  local lfolder
  local lfname
  if [ -z $1 ] ; then
    lfolder=values
    lfname=$LANG_WORK_DIR/en/vflist
  else
    lfolder=values-$1
    lfname=$LANG_WORK_DIR/$1/vflist
  fi

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

function lang_copy_strings()
{
  lang_find_values $1
}

function lang_rm_work_dir()
{
  LANG_WORK_DIR=
  rm -rf $LANG_ROOT/2014*
}

function lang_strings_xml2cvs()
{
  local R3=$RED_ROOT/r3
  local xml2cvs=$RED_ROOT/xml2cvs.r
  local lfname=$LANG_WORK_DIR/$1/vflist

  cat $lfname | while read line
  do
    local lfsrc=$LANG_WORK_DIR/$1/$line/strings.xml
    if [ -f $lfsrc ] ; then
      $R3 $xml2cvs $lfsrc
    fi
  done

}
