REBOL [
  title: "manifest module"
  name: 'manifest
  type: 'module
  version: 1.0.0
  date: 26-Jan-2014
  file: %manifest.r
  needs: [ %menu-util.r %git-util.r ]
  exports: [ ]
]

qct-remote: {ssh://192.168.180.185:29418/qct/platform/manifest.git}
qct-local: %/tmp/qct-manifest/

init: func [] [
  either git-valid reduce [ qct-remote ] qct-local [
    git-pull qct-local
  ] [
    git-clone qct-remote qct-local
  ]
]

get-xml: func [
] [
  do Build/Lable/LA
]

clone: func [
] [
]

;;;--------------------------------------------------------
menutree: [
  {?} [ cmd-show menutree ] {help}
  {q} [ print "back TOP" break ] {back TOP}
]

prompt: {TOP>Manifest> Command (? for help):}

menu: func [] [
  forever [ cmd-input prompt menutree ]
]
