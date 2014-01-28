REBOL [
  title: "chipcode info manager"
  name: 'chipcode
  type: 'module
  version: 1.0.0
  date: 24-Jan-2014
  file: %chipcode.r
  needs: [ %menu-util.r %git-util.r ]
  exports: [ Build ]
]

;;;--------------------------------------------------------
Build: [
  Product [ first get-manifest ]
  Distribution [ second get-manifest ]
  Lable [
    LA [ last get-manifest ]
  ]
]
;;;--------------------------------------------------------
data-file: %chipcode.dat

repo: []
list: []
cur: none

init: func [
  /local dat
] [
  try [
    dat: load data-file
    repo: first dat
    list: second dat
    cur: last dat
    if not cur [ attempt [ first list ]]
  ]
]

save-data: does [
  save data-file reduce [ repo list cur ]
]

ls: func [
  /remote "show remote repositories on gerrit"
  /local i
] [
  i: 0
  either remote [
    foreach [n v k] repo [
      i: i + 1
      print [ i "." v k ]
    ]
  ] [
    foreach path list [
      i: i + 1
      print reduce [ i "." path]
    ]
  ]
]

search: func [
  /home "search under home"
  /path "search under assigned path"
  s-path "user assign a search path"
] [
  print "TODO"
]

add: func [ /local path ] [
  path: ask "please input your local path of chipcode:"
  ;;TODO
  ;;1.path not start with %
  ;;2.path not end with /
  ;;3.path not exist,make-dir %new-dir
  append list to-path path
  save-data
]

choose: func [ /local ans] [
  ls
  ans: ask "please choose one:"
  cur: pick list to-integer ans
  save-data
  print [ "current chipcode:" cur ]
]

clone: func [
  /local src dest
] [
  ls/remote
  src: ask "select which one you want to clone:"
  dest: ask "input where you want to clone:"
  git-clone select repo src dest
  append list append to-file dest {/}
  save-data
]

examine: func [
] [
  git-valid repo cur
]

get-manifest: func [
  {prase about.html, to get android repo manifest}
  /local vv v
] [
  vv: make block! 4
  parse read/string rejoin [ cur "about.html" ] [
    thru {<table} thru {<tr>} thru {<tr>}
    thru {<td>} copy v [ to {</td>} ] ( append vv v )
    thru {<td>} copy v [ to {</td>} ] ( append vv v )
    thru {<table} thru {<tr>} thru {<tr>}
    thru {<td>} copy v [ to {</td>} ] ( append vv v )
    thru {<td>} copy v [ to {</td>} ] ( append vv v )
  ]
  vv
]

info: func [
  /local vers br
] [
  vers: get-manifest
  br: git-branch cur
  print [ "local:" cur ]
  print [ "remote:" git-remote cur]
  print [ "chipcode ver:" vers/1 vers/2 ]
  print [ "LA ver:" vers/4 ]
  print [ "branch:" br/1 ]
]

;;;--------------------------------------------------------
menutree: [
  {i} [ if examine [ info ]] {show current info}
  {c} [ clone ] {clone a new chipcode}
  {s} [ choose ] {choose one to use}
  {a} [ add ] {add one new local path}
  {e} [ examine ] {examine current code}
  {?} [ cmd-show menutree ] {help}
  {q} [ print "back TOP" break ] {back TOP}
]

prompt: {TOP>ChipCode> Command (? for help):}

menu: func [] [
  forever [ cmd-input prompt menutree ]
]
