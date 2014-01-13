export LANG_ROOT=$SHELL_ROOT/lang
LANG_VARS_FILE=$LANG_ROOT/vars.sh
LANG_GETS_FILE=$LANG_ROOT/gets.sh

function lang_menu()
{
  echo "==================== LANG strings.xml Kit ===================="

  echo -n "0.rechoose languages code [$LANG_CODE]"
  if [ -n $LANG_CODE ] ; then  echo " --> done!"; fi
  echo -n "1.rechoose work dir [$LANG_WORK_DIR]"
  if [ -n $LANG_WORK_DIR ] ; then  echo " --> done!"; fi
  echo "2.copy en strings.xml [$LANG_WORK_DIR/en]"
  echo "3.copy $LANG_CODE strings.xml [$LANG_WORK_DIR/$LANG_CODE]"
  echo "c.clean work dirs"
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
      lang_copy_strings
      lang_load
      ;;
    3) echo "find values-$LANG_CODE ..."
      lang_copy_strings $LANG_CODE
      lang_load
      ;;
    c) echo "will remove all work dirs ..."
      lang_rm_work_dir
      lang_reload
      ;;
    q) echo "Bye!"
      ;;
    *) echo "[ERROR] Invaild input!"
      lang_load
      ;;
  esac

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
