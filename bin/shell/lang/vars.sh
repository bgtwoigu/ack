LANG_USER_FILE=$LANG_ROOT/user.sh
if [ -f $LANG_USER_FILE ] ; then
  source $LANG_USER_FILE
fi


function lang_uninit_var()
{
  echo "#user defined for lang" > $LANG_USER_FILE
  echo "LANG_CODE=$LANG_CODE" >> $LANG_USER_FILE
  echo "LANG_WORK_DIR=$LANG_WORK_DIR" >> $LANG_USER_FILE
}

function lang_init_var()
{
  if [ "$LANG_CODE" = "" ] ; then
    echo "lang init vars"
    echo -n "input lang code:"
    local lcode
    read lcode
    if [ $lcode ] ; then
      LANG_CODE=$lcode
    fi
  fi

  if [ "$LANG_WORK_DIR" = "" ] ; then
    LANG_WORK_DIR="$LANG_ROOT/`date +%Y%m%d%H%M%S`"
    mkdir -p $LANG_WORK_DIR
  fi

  lang_dump
  lang_write_to_user
}

function lang_write_to_user()
{
  echo "#user defined for lang" > $LANG_USER_FILE
  echo "LANG_CODE=$LANG_CODE" >> $LANG_USER_FILE
  echo "LANG_WORK_DIR=$LANG_WORK_DIR" >> $LANG_USER_FILE
}

function lang_dump()
{
  echo LANG_WORK_DIR=$LANG_WORK_DIR
  echo LANG_CODE=$LANG_CODE
}

lang_init_var
