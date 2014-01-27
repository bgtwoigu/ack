REBOL [
  title: "menu utils"
  name: 'menu-util
  version: 1.0.0
  date: 27-Jan-2014
  file: %menu-util.r
  exports: [ cmd-show cmd-input ]
]

cmd-show: func [
  menutree
] [
  print ""
  foreach [m act desc] menutree [
    print [ "  " m #"^(tab)" desc ] 
  ]
]

cmd-input: func [
  prompt
  menutree
  /local ans
] [
  print ""
  ans: ask prompt
  switch ans menutree
]
