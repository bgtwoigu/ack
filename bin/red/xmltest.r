REBOL [
  title: "script example"
  author: "vpavlu"
  date: 12-Dec-2002
  version: 1.0.0
]
do %rebelxml.r
load-xml-data read/string %strings.xml
keys: get-xml-data/attribute 'string 'name
foreach k keys [
  v: get-xml-data/content/with-attribute 'resources/string 'name k
print [ k "=" v ]
]
