REBOL [
  title: "code kit menu"
  name: 'menu
  version: 1.0.0
  date: 24-Jan-2014
  file: %menu.r
  needs: [ %load.r %menu-util.r ]
  exports: [ ]
]

menutree: [
  {u} [ ut/menu ] {git url}
  {c} [ cc/menu ] {chipcode}
  {m} [ mx/menu ] {manifest}
  {?} [ cmd-show menutree ] {help}
  {q} [ print "Bye!" break ] {quit!}
]

prompt: {TOP> Command (? for help):}

forever [ cmd-input prompt menutree ]
