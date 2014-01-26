REBOL [
  title: "code kit menu"
  name: 'menu
  version: 1.0.0
  date: 24-Jan-2014
  file: %menu.r
  needs: [ %load.r ]
  exports: [ menu ]
]

menutree: [
  {c} [ forever [ menu cc/prompt cc/menutree ]] {chipcode}
  {m} [ forever [ mx/menu ]] {manifest}
  {?} [ help ] {help}
  {q} [ print "Bye!" break ] {quit!}
]

help: func [] [
  foreach [m act desc] menutree [
    print [ "  " m #"^(tab)" desc ] 
  ]
]

prompt: {TOP> Command (? for help):}

menu: func [
  prompt
  menutree
  /local ans
] [
  ans: ask prompt
  switch ans menutree
]

forever [ menu prompt menutree ]
