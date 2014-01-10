CUR_PROJECT_ROOT=
ANDROID_ROOT=
android_xml_dest=qmss1935-8x10.xml

if [ "$CUR_PROJECT_ROOT" = "" ] ; then
  echo "pls input your chipcode path,eg /home/xxx/qmss19"
  echo -n ":"
  local cc_path
  read cc_path
  if [ "$cc_path" ] ; then
    CUR_PROJECT_ROOT=$cc_path
  fi
fi

ANDROID_ROOT="$CUR_PROJECT_ROOT/LINUX/android"
if [ ! -d "$ANDROID_ROOT" ] ; then
  ANDROID_ROOT="$CUR_PROJECT_ROOT"
fi


