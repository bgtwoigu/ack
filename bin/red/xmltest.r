REBOL [
  title: "script example"
  author: "vpavlu"
  date: 12-Dec-2002
  version: 1.0.0
]
print "hello world"
do %rebelxml.r
load-xml-data read/string %strings.xml
print get-xml-data/content/with-attribute 'resources/string 'name "yes"
