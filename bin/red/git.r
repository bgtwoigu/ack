REBOL [
  title: "git util"
  name: 'git
  type: 'module
  version: 1.0.0
  date: 28-Jan-2014
  file: %git.r
  exports: [
    gitcmd git-clone git-remote git-branch
    git-pull git-tag
  ]
]

git-clone: func [
  src "select which one you want to clone"
  dest "input where you want to clone"
] [
  call/wait reform [ "git clone" src dest ]
]

git-remote: func [
  cur "current code path"
] [
  trim second
    split trim
      select
        read/lines rejoin [ cur {.git/config} ]
        {[remote "origin"]}
      #"="
]

git-branch: func [
  cur "current code path"
  /remote
  remote-name
  /local heads
] [
  heads: copy/deep [ [] [] [] ]
  foreach f read rejoin [ cur {.git/refs/heads/} ] [
    append heads/1 to-string f
    append heads/1 first read/lines rejoin [ cur {.git/refs/heads/} f ]
  ]

  foreach f read rejoin [ cur {.git/refs/remotes/} remote-name {/} ] [
    append heads/2 to-string f
    append heads/2
      first read/lines rejoin [ cur {.git/refs/remotes/} remote-name {/} f ]
  ]

  if not select heads/2 "master" [
    foreach line read/lines rejoin [ cur {.git/packed-refs} ] [
      if find line
              trim second split select heads/2 "HEAD" #":" [
        append heads/2 fourth split line #"/"
        append heads/2 first split line #" "
      ]
    ]
  ]

  append heads/3
    third split first read/lines rejoin [ cur {.git/HEAD} ] #"/"

  heads
]

git-tag: func [
  cur "current code path"
  /local tags
] [
  tags: make block! 8
  foreach f read rejoin [ cur {.git/refs/tags/} ] [
    append tags to-string f
    ;append tags first read/lines rejoin [ cur {.git/refs/heads/} f ]
  ]
]

gitcmd: func [
  cur "current code path"
  cmd
  /bare "no --work-tree"
  /debug "only print cmd"
  /local mycmd
] [
  either debug [
    mycmd: :print
  ] [
    mycmd: :call
  ]

  mycmd reform [
    rejoin [ {git --git-dir=} to-string cur
      either find cur ".git" [] [ ".git" ]
    ]
    either bare [] [ rejoin [ { --work-tree=} to-string cur ]]
    reform cmd
  ]
]

git-pull: func [
  cur "current code path"
] [
  gitcmd cur "pull"
]
