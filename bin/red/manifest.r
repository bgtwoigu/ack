REBOL [
  title: "manifest module"
  name: 'manifest
  type: 'module
  version: 1.0.0
  date: 26-Jan-2014
  file: %manifest.r
  needs: [ %menu-util.r %git-util.r %repo.r ]
  exports: [ ]
]

;;;--------------------------------------------------------
data-file: %manifest.dat

qct-remote: none
cur-remote: none
qct-local: %/tmp/qct-manifest/

init: func [
  /local dat
] [
  try [
    dat: load data-file
    qct-remote: first dat
    cur-remote: second dat
  ]
]

update: func [
  /remote "update remote repositories"
] [
  if remote [
    gitcmd/bare qct-remote "fetch"
  ]
  either git-valid reduce [ qct-remote ] qct-local [
    git-pull qct-local
  ] [
    git-clone qct-remote qct-local
  ]
]

get-xml: func [
  /local xml
] [
  xml: first reduce Build/Lable/LA
  clear find/last xml #"-"
  append xml ".xml"
]

examine: func [
] [
  prin [ "checking " get-xml "... " ]
  if not exists? append copy qct-local get-xml [
    print "Not found"
    return false
  ]
  print "OK!"
  true
]

info: func [
] [
  print [ {manifest.xml -> } get-xml ]
]

gen-xml: func [
  /local org
] [
  org: get-xml
  
]

sync: func [
] [

]

;;;--------------------------------------------------------
menutree: [
  {i} [ info ] {show current info}
  {u} [ update/remote ] {update manifest both local and remote}
  {s} [ sync ] {sync android code}
  {e} [ examine ] {examine current manifest}
  {?} [ cmd-show menutree ] {help}
  {q} [ print "back TOP" break ] {back TOP}
]

prompt: {TOP>Manifest> Command (? for help):}

menu: func [] [
  forever [ cmd-input prompt menutree ]
]
