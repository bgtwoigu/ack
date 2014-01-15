REBOL [
  title: "say hello"
  version: 1.0.0
]
say-hello: func [
  "say hello to you"
][
greeting: either now/time < 12:00
  [ "morning" ]
  [ "afternoon" ]
name: ask {what is your name=> }
print [ "Good" greeting name ]
]
