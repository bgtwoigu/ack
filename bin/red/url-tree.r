REBOL [
  title: "url-tree"
  name: 'url-tree
  type: 'module
  version: 1.0.0
  date: 11-Feb-2014
  file: %url-tree.r
  needs: [ %menu-util.r %git-url.r ]
  export-ids: [
    LAURL
  ]
]

;;;--------------------------------------------------------
info: func [
] [
  print [ {org/qaep} org-qaep/url ]
]


;;;--------------------------------------------------------
url-tree: make object! [
org-qaep: make base-url [
  scheme: {git}
  host: {codeaurora.org}
  port-id: {}
  root: {/}
  path: {platform/manifest.git}
]

org-cymod: make base-url [
  scheme: {git}
  host: {github.com}
  port-id: {}
  root: {/CyanogenMod/}
  path: {android.git}
]

LAURL: [
  qaep: [
    key: 'qaep
    org: [ org-qaep/url ]
    mirror: [ org-qaep/url ]
  ]
  cymod: [
    key: 'cymod
    org: [ org-cymod/url ]
    mirror: [ org-cymod/url ]
  ]
]

gen-word: func [
  'word [word!]
] [
  to-word rejoin [ "org-" word ]
]

words: [mirror-qaep mirror-cymod]
create: func [
] [
  ;bind/new words org-qaep
  intern words
  set 'mirror-qaep make-url/url to url! {ssh://git@192.168.180.185:/code/tool/qaep/qct/platform/manifest.git}
]
]
;;;--------------------------------------------------------
data-file: %git-url.dat

init: func [
  /local dat
] [
  try [
    dat: load date-file
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
