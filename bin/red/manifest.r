REBOL [
  title: "manifest module"
  name: 'manifest
  type: 'module
  version: 1.0.0
  date: 26-Jan-2014
  file: %manifest.r
  exports: [ ]
]

qct-path: {ssh://192.168.180.185:29418/qct/platform/manifest.git}

;;;--------------------------------------------------------

menu: func [] [
  print "manifest menu"
]
