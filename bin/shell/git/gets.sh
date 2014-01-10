android_ver=
android_xml=

function get_ver_LA()
{
  android_ver=`$QGIT show refs/remotes/origin/master -- about.html \
    | grep "^+.*LNX" \
    | cut -d ">" -f 2 | cut -d "<" -f 1 | cut -d "-" -f 1-3`
  echo android_ver=$android_ver
}

function get_manifest_xml()
{
  get_ver_LA
  android_xml=$android_ver.xml
  echo android_xml=$android_ver.xml

  $MGIT fetch
  $MGIT reset --hard
  $MGIT pull origin goso
  $MGIT checkout origin/release
  $MGIT reset --hard
  cp $MANIFEST_DIR/$android_xml /tmp/
  cp $MANIFEST_DIR/default_$android_xml /tmp/

  $MGIT checkout default
  vimdiff /tmp/default_$android_xml $MANIFEST_DIR/gerrit/$android_xml_dest


  echo -n "Is $android_xml_dest ok?(y/n)"
  local answer_yn
  read answer_yn

  if [ "$answer_yn" = "y" ]
  then
    commit_push_xml
  else
    echo "pls manual modify $android_xml_dest"
    echo "when ok, run commit_push_xml"
  fi
}

function commit_push_xml()
{
  echo "1.rename $android_xml_dest"
  echo "2.commit&push $android_xml_dest"
  echo -n "choose:"
  local answer
  local new_name
  read answer

  if [ "$answer" = "1" ] ; then
    echo -n "input new xml name(end whit .xml):"
    read new_name
    if [ "$new_name" ] ; then
      cp $MANIFEST_DIR/gerrit/$android_xml_dest $MANIFEST_DIR/gerrit/$new_name
      answer=2
    fi
  fi
  if [ "$answer" = "2" ] ; then
    if [ "$new_name" ] ; then
      $MGIT add gerrit/$new_name
      $MGIT checkout gerrit/$android_xml_dest
      $MGIT commit -m "add $new_name"
    else
      $MGIT add gerrit/$android_xml_dest
      $MGIT commit -m "update $android_xml_dest"
    fi
    $MGIT push origin HEAD:refs/for/goso
  fi
}

get_manifest_xml
