REBOL [
  title: "transform strings.xml to strings.csv"
  version: 1.0.1
  ;needs: [ altxml 0.4.0 ]
]

xml2csv: func [
  "transform android strings.xml to csv"
][
  print [ "transform" system/options/args ]
  myxml: load-xml/dom to-file system/options/args
  str-arr: myxml/get-by-tag <string>
  strs: ""
  foreach str str-arr [
    append strs rejoin [
    str/get #name "|" str/text #"^/"
    ]
  ]
  newfile: copy system/options/args
  newfile: replace to-string newfile ".xml" ".csv"
  write to-file newfile strs
]

import %r3xml.r
xml2csv
