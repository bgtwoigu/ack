REBOL [
  title: ""
  name: 'date-util
  type: 'module
  version: 1.0.0
  file: %mm.reb
  exports: [ date-util ]
]

say-hello: func [
  {say hello to you}
][
greeting: either now/time < 12:00
  [ "morning" ]
  [ "afternoon" ]
name: ask {what is your name=> }
print [ "Good" greeting name ]
]
