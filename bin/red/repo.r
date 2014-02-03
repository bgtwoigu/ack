REBOL [
  title: "repo"
  name: 'repo
  type: 'module
  version: 1.0.0
  date: 29-Jan-2014
  file: %repo.r
  exports: [
  ]
]

repocmd: func [
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

repo-init: func [
  cur "current code path"
] [
  gitcmd cur "pull"
]
