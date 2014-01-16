export LANG_ROOT=$SHELL_ROOT/lang
LANG_VARS_FILE=$LANG_ROOT/vars.sh
LANG_GETS_FILE=$LANG_ROOT/gets.sh
USE_TIME=

function lang_menu()
{
  echo "==================== LANG strings.xml Kit ===================="

  echo -n "0.rechoose languages code [$LANG_CODE]"
  if [ -n $LANG_CODE ] ; then  echo " --> done!"; fi
  echo -n "1.rechoose work dir [$LANG_WORK_DIR]"
  if [ -n $LANG_WORK_DIR ] ; then  echo " --> done!"; fi
  echo "2.copy en strings.xml [$LANG_WORK_DIR/en]"
  echo "3.copy $LANG_CODE strings.xml [$LANG_WORK_DIR/$LANG_CODE]"
  echo "4.transform strings.xml to strings.cvs"
  echo "5.transform strings.xml to strings.cvs"
  echo "c.clean work dirs"
  echo "t.use time [$USE_TIME]"
  echo "q.quit"

  echo -n ":"
  local mtodo
  read mtodo

  case $mtodo in
    0) echo "NOTE: languages code are en,cn,fr etc."
      LANG_CODE=
      lang_reload
      ;;
    1) echo "create a new dir..."
      LANG_WORK_DIR=
      lang_reload
      ;;
    2) echo "find values ..."
      $USE_TIME lang_copy_strings
      lang_load
      ;;
    3) echo "find values-$LANG_CODE ..."
      $USE_TIME lang_copy_strings $LANG_CODE
      lang_load
      ;;
    4) echo "transform strings.xml under $LANG_WORK_DIR/en ..."
      $USE_TIME lang_strings_xml2cvs en
      lang_load
      ;;
    5) echo "transform strings.xml under $LANG_WORK_DIR/$LANG_CODE ..."
      $USE_TIME lang_strings_xml2cvs $LANG_CODE
      lang_load
      ;;
    c) echo "will remove all work dirs ..."
      lang_rm_work_dir
      lang_reload
      ;;
    t) echo "use time on/off"
      lang_switch_time
      ;;
    q) echo "Bye!"
      ;;
    *) echo "[ERROR] Invaild input!"
      lang_load
      ;;
  esac

}

function lang_switch_time()
{
  local tstate=
  if [ "$USE_TIME" = "time" ] ; then
    tstate='on'
  fi
  if [ "$USE_TIME" = "" ] ; then
    tstate='off'
  fi
  if [ "$tstate" = "on" ] ; then
    USE_TIME=
  fi
  if [ "$tstate" = "off" ] ; then
    USE_TIME=time
  fi
}

function lang_reload()
{
  lang_uninit_var
  lang_load
}

function lang_load()
{
  source $LANG_VARS_FILE
  source $LANG_GETS_FILE
  lang_menu
}

lang_load
