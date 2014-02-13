REBOL [
  title: "url-tree"
  name: 'url-tree
  type: 'module
  version: 1.0.0
  date: 11-Feb-2014
  file: %url-tree.r
  needs: [ %menu-util.r %git-url.r ]
  exports: [
    URLTREE
  ]
]

;;;--------------------------------------------------------

gen-word: func [
  'word [word!]
] [
  to-word rejoin [ "org-" word ]
]

new: func [
  dat [block!]
] [
  make object! [
    org: make-url/url to url! dat/org/url
    mirror: make-url/url to url! dat/mirror/url
    gerrit: make-url/url to url! dat/gerrit/url
    git: make-url/url to url! dat/git/url
  ]
]

;;;--------------------------------------------------------
URLDAT: context []
URLTREE: context [
  words: [
    android: [ 'qaep ]
    chipcode: [ 'qrd8x10 'qrd8x26 'qrd8926 'qct8x74kk ]
  ]
  qaep: [ URLDAT/qaep ]
  qrd8x10: [ URLDAT/qrd8x10 ]
  qrd8x26: [ URLDAT/qrd8x26 ]
  qrd8926: [ URLDAT/qrd8926 ]
  qct8x74kk: [ URLDAT/qct8x74kk ]
]
data-file: %url-tree.dat

info: func [
  /local words obj
] [
  words: copy URLTREE/words/android
  append words URLTREE/words/chipcode
  foreach v words [
    obj: do get in URLDAT v
    print [ to set-word! v obj/gerrit/url ]
  ]
]

init: func [
  /local dat blk words
] [
  try [
    dat: load data-file
    blk: []
    words: copy URLTREE/words/android
    append words URLTREE/words/chipcode
    foreach v words [
      append blk reduce [ to-set-word v new select dat v ]
    ]
    URLDAT: make object! blk
  ]
]
;;;--------------------------------------------------------
menutree: [
  {i} [ info ] {show current info}
  {?} [ cmd-show menutree ] {help}
  {q} [ print "back TOP" break ] {back TOP}
]

prompt: {TOP>URL> Command (? for help):}

menu: func [] [
  forever [ cmd-input prompt menutree ]
]
