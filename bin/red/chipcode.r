REBOL [
  title: "chipcode info manager"
  name: 'chipcode
  type: 'module
  version: 1.0.0
  date: 24-Jan-2014
  file: %chipcode.r
  needs: [ %menu-util.r ]
  exports: [ ]
]

repo: [
 "1" {ssh://192.168.180.185:29418/qmss19-8x10.git}     qrd8x10
 "2" {ssh://192.168.180.185:29418/qmss16.git}          qrd8x26
 "3" {ssh://192.168.180.185:29418/qmss11-8926.git}     qrd8926
 "4" {ssh://192.168.180.185:29418/amss20-8x74.git}     qct8x74
 "5" {ssh://192.168.180.185:29418/amss201-8x74.git}  qct8x74kk
]

data-file: %chipcode.dat

list: try/except [ load data-file ] [ [] ]

cur: attempt [ first list ]

load-data: does [
  list: try/except [ load data-file ] [ [] ]
]

save-data: does [
  save data-file list
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
      print [ i "." path]
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
  print [ "currunt chipcode:" cur ]
]

clone: func [
  /local src dest
] [
  ls/remote
  src: ask "select which one you want to clone:"
  dest: ask "input where you want to clone:"
  call/wait reform [ "git clone" select repo src dest ]
]

get-remote: func [] [
  trim second
    split trim
      select
        read/lines rejoin [ cur ".git/config" ]
        {[remote "origin"]}
      #"="
]

get-branches: func [
  /local heads
] [
  heads: make block! 2
  foreach f read rejoin [ cur {.git/refs/heads/} ] [
    append heads to-string f
    append heads first read/lines rejoin [ cur {.git/refs/heads/} f ]
  ]
]

examine: func [
  {check git remote in repo,
   check current branch not in master, in correct branch version
  }
] [
  prin [ "checking " cur "... " ]
  either select repo get-remote [
    print "OK!"
    true
  ] [
    print "FAIL!"
    none
  ]
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

info: func [] [
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
