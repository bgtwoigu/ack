REBOL [
  title: "git util"
  name: 'git
  type: 'module
  version: 1.0.0
  date: 28-Jan-2014
  file: %git.r
  exports: [
    git-clone git-remote git-branch
    git-pull
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
  /local heads
] [
  heads: make block! 2
  foreach f read rejoin [ cur {.git/refs/heads/} ] [
    append heads to-string f
    append heads first read/lines rejoin [ cur {.git/refs/heads/} f ]
  ]
]

gitcmd: func [
  cur "current code path"
  cmd
] [
  call/wait reform [
    rejoin [
    {git --git-dir=} to-string cur {.git}
    { --work-tree=} to-string cur
    ]
    cmd
  ]
]

git-pull: func [
  cur "current code path"
] [
  gitcmd cur "pull"
]
