export GIT_ROOT=$SHELL_ROOT/git
GIT_VARS_FILE=$GIT_ROOT/vars.sh
GIT_GETS_FILE=$GIT_ROOT/gets.sh

      source $GIT_VARS_FILE

function git_menu()
{
  echo "==================== Git Kit ===================="

  echo "1.search xml"
  echo ".get modify list:log prety=oneline"
}

git_menu
