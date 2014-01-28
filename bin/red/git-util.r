REBOL [
  title: "git util ext"
  name: 'git-util
  type: 'module
  version: 1.0.0
  date: 28-Jan-2014
  file: %git-util.r
  needs: [ %git.r ]
  exports: [ git-exists git-valid ]
]

git-exists: func [
  cur
] [
  if exists? append copy cur {.git/config} [
    true
  ]
]

git-valid: func [
  {check git remote in repo,
   check current branch not in master, in correct branch version
  }
  repo [ block! ]
  cur
] [
  prin [ "checking " cur "... " ]
  if not git-exists cur [
    print "Not Exits"
    return false
  ]
  either select repo git-remote cur [
    print "OK!"
    true
  ] [
    print "FAIL!"
    false
  ]
]
