
QMSS_DIR="$CUR_PROJECT_ROOT"
ANDROID_ROOT="$QMSS_DIR/LINUX/android"

QGIT_DIR="$QMSS_DIR"
MANIFEST_DIR="$ANDROID_ROOT/.repo/manifests"

QGIT="git --git-dir=$QGIT_DIR/.git --work-tree=$QGIT_DIR"
MGIT="git --git-dir=$MANIFEST_DIR/.git --work-tree=$MANIFEST_DIR"
AGIT="git --git-dir=$ANDROID_ROOT/$PROJ/.git --work-tree=$ANDROID_ROOT/$PROJ"

