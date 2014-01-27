REBOL [
  title: "manifest module"
  name: 'manifest
  type: 'module
  version: 1.0.0
  date: 26-Jan-2014
  file: %manifest.r
  needs: [ %menu-util.r ]
  exports: [ ]
]

qct-path: {ssh://192.168.180.185:29418/qct/platform/manifest.git}

;;;--------------------------------------------------------
menutree: [
  {?} [ cmd-show menutree ] {help}
  {q} [ print "back TOP" break ] {back TOP}
]

prompt: {TOP>Manifest> Command (? for help):}

menu: func [] [
  forever [ cmd-input prompt menutree ]
]
