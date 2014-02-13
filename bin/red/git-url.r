REBOL [
  title: "git-url"
  name: 'git-url
  type: 'module
  version: 1.0.0
  date: 08-Feb-2014
  file: %git-url.r
  exports: [
    base-url make-url
  ]
]

base-url: make object! [
  scheme: copy ""
  user: copy ""
  host: copy ""
  port-id: copy ""
  root: copy ""
  path: copy ""
  ssh: func [
    /local out
  ] [
    out: copy ""
    append out {ssh }
    if user <> "" [ append out rejoin [user "@" ]]
    append out host
    out
  ]
  url: func [
    /localpath
    /local out
  ] [
    out: copy ""
    if not localpath [
      append out rejoin [ scheme "://" ]
      if user <> "" [ append out rejoin [user "@" ]]
      append out host
      if port-id <> "" [ append out rejoin [ ":" port-id ]]
    ]
    append out rejoin [ root path ]
    out
  ]
]

make-url: func [
  /url
  u [url!]
  /obj
  o [object!]
  /init
  params [block!]
  /scheme
  se [string!]
  /host
  ht [string!]
  /port-id
  pt [string!]
  /root
  rt [string!]
  /path
  ph [string!]
  /local ret words blk
] [
  either obj [
    ret: make o []
  ] [
    ret: make base-url []
  ]

  if url [
    foreach [w v] decode-url u [
      set in ret w v
      if "path:" == (to string! w) [
        set in ret 'root "/"
        set in ret 'path next v
      ]
    ]
  ]
  if init [
    words: [ scheme host port-id root path ]
    while [ not tail? params ] [
      set in ret first words first params
      params: next params
      words: next words
    ]
  ]
  if scheme [
    ret: make ret [
      scheme: se
    ]
    if (se == "ssh") and (not port-id) [
      ret: make ret [
        port-id: "22"
      ]
    ]
  ]
  if host [
    ret: make ret [
      host: ht
    ]
  ]
  if root [
    ret: make ret [
      root: rt
    ]
  ]
  if path [
    either (first ph) == #"/" [
      blk: reduce [root: "/" path: next ph]
    ] [
      blk: reduce [path: ph]
    ]
    ret: make ret blk
  ]
  if port-id [
    ret: make ret [
      port-id: pt
    ]
  ]
  ret
]
