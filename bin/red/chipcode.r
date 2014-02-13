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
  Local [ cur ]
]
;;;--------------------------------------------------------
data-file: %chipcode.dat

list: []
cur: none

init: func [
  /local dat
] [
  try [
    dat: load data-file
    list: first dat
    cur: last dat
    if not cur [ attempt [ first list ]]
  ]
]

save-data: does [
  save data-file reduce [ list cur ]
]

geturls: func [
  /chipcode
  /gerrit
  /git
  /localpath
  /ssh
  /local dat repo obj
] [
  repo: copy []
  if chipcode [
    dat: URLTREE/words/chipcode
    foreach d dat [
      obj: do get in URLTREE d
      append repo reduce [ d ]
      if gerrit [append repo reduce [ obj/gerrit/url ]]
      if git [append repo reduce [ obj/git/url ]]
      if localpath [append repo reduce [ obj/git/url/localpath ]]
      if ssh [append repo reduce [ obj/git/ssh ]]
    ]
  ]
  repo
]

ls: func [
  /remote "show remote repositories on gerrit"
  /local i
] [
  i: 0
  either remote [
    foreach [k v] geturls/chipcode/gerrit [
      i: i + 1
      print [ i "." k v ]
    ]
  ] [
    foreach path list [
      i: i + 1
      print reduce [ i "." path]
    ]
  ]
]

update: func [
  /remote "update remote repositories"
  /local i
] [
  i: 0
  either remote [
    foreach [k v ssh] geturls/chipcode/localpath/ssh [
      i: i + 1
      print [ i "." v "updating ..." ]
      gitcmd/bare/remote v "fetch" ssh
    ]
  ] [
    foreach path list [
      i: i + 1
      print reduce [ i "." path "updating ..." ]
      gitcmd path "fetch"
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

choose: func [
  /local ans brs i
] [
  ls
  ans: ask "please choose one:"
  cur: pick list to-integer ans
  save-data
  print [ "current chipcode:" cur ]

  brs: git-branch/remote cur "origin"
  i: 0
  print [ "local branches are:" ]
  foreach [b sha] brs/1 [
    i: i + 1
    print [ i "." b "->" sha ]
  ]
  print [ "remote branches are:" ]
  foreach [b sha] brs/2 [
    i: i + 1
    print [ i "." b "->" sha ]
  ]

  print [ "current branch:" brs/3 ]

  if find brs/3 "master" [
    ans: to-integer ask "change branch:"
    if (ans > 0) & (ans <= ((length? brs/1) / 2)) [
      gitcmd cur [ "checkout" brs/1/(ans * 2 - 1) ]
    ]
    ans: ans - ((length? brs/1) / 2)
    if (ans > 0) & (ans <= ((length? brs/2) / 2)) [
      gitcmd cur [ "checkout -b" brs/2/(ans * 2 - 1)
                  rejoin [ "origin/" brs/2/(ans * 2 - 1)] ]
    ]
  ]
]

clone: func [
  /local src dest
] [
  ls/remote
  src: ask "select which one you want to clone:"
  dest: ask "input where you want to clone:"
  git-clone pick geturls/chipcode/gerrit ((to-integer src) * 2) dest
  append list append to-file dest {/}
  save-data
]

examine: func [
] [
  git-valid geturls/chipcode/gerrit cur
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
  br: git-branch/remote cur "origin"
  print [ "local:" cur ]
  print [ "remote:" git-remote cur]
  print [ "chipcode ver:" vers/1 vers/2 ]
  print [ "LA ver:" vers/4 ]
  print [ "branch:" br ]
]

;;;--------------------------------------------------------
menutree: [
  {i} [ if examine [ info ]] {show current info}
  {c} [ clone ] {clone a new chipcode}
  {s} [ choose ] {choose one to use}
  {l} [ ls ls/remote ] {list both local and remote}
  {u} [ update ] {update local}
  {r} [ update/remote ] {update remote}
  {a} [ add ] {add one new local path}
  {e} [ examine ] {examine current code}
  {?} [ cmd-show menutree ] {help}
  {q} [ print "back TOP" break ] {back TOP}
]

prompt: {TOP>ChipCode> Command (? for help):}

menu: func [] [
  forever [ cmd-input prompt menutree ]
]
