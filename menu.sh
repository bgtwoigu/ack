export SHELL_ROOT=bin/shell
LOCAL_FILE=$SHELL_ROOT/local.sh
GIT_MENU_FILE=$SHELL_ROOT/git/gitmenu.sh

function main_menu()
{
  echo "============== Android Code Kit ================================="
  echo "0.choose code path [$CUR_PROJECT_ROOT]"
  echo "1.upgrade qcom baseline"
  echo "2.get languages"
  echo -n ":"
  local mtodo
  read mtodo 

  case $mtodo in
    0) echo "NOTE: this will change the chipcode path!"
      reload
      ;;
    1) echo "init git code..."
      source $GIT_MENU_FILE
      ;;
    2) echo "init lang..."
      ;;
  esac
}

function reload()
{
  uninit_local
  menu
}

function menu()
{
  source $LOCAL_FILE
  main_menu
}

menu
