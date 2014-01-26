REBOL [
  title: "chipcode info manager"
  name: 'chipcode
  type: 'module
  version: 1.0.0
  date: 24-Jan-2014
  file: %chipcode.r
  exports: [ ]
]

repo: [
  qrd8x10: {ssh://192.168.180.185:29418/qmss19-8x10.git}
  qrd8x26: {ssh://192.168.180.185:29418/qmss16.git}
  qrd8926: {ssh://192.168.180.185:29418/qmss11-8926.git}
  qct8x74: {ssh://192.168.180.185:29418/amss20-8x74.git}
  qct8x74kk: {ssh://192.168.180.185:29418/amss201-8x74.git}
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
] [
  either remote [
    foreach [k v] repo [
      print v
    ]
  ] [
    foreach path list [
      print path
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

add: func [ path [file!] ] [
  append list path
]

choose: func [ /local i ans] [
  i: 0
  foreach path list [
    i: i + 1
    print [ i ":" path]
  ]
  ans: ask "please choose one:"
  cur: pick list to-integer ans
  print [ "currunt chipcode:" cur ]
]

;;;--------------------------------------------------------
menutree: [
  {c} [ choose ] {choose one to use}
  {a} [ add ] {add one local path}
  {?} [ help ] {help}
  {q} [ print "back TOP" break ] {back TOP}
]

help: func [] [
  foreach [ m ack desc ] menutree [
    print [ "  " m #"^(tab)" desc ]
  ]
]

prompt: {TOP>ChipCode> Command (? for help):}
menu: func [ /local ans ] [
  ans: ask "TOP>ChipCode> Command (? for help):"
  switch ans menutree
]
