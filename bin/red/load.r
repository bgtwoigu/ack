REBOL [
  title: "load module"
  name: 'load
  type: 'module
  version: 1.0.0
  date: 26-Jan-2014
  file: %load.r
  exports: [ ut cc mx ]
]

ut: import %url-tree.r
ut/init
cc: import %chipcode.r
cc/init
mx: import %manifest.r
mx/init
