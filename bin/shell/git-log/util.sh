function git-log {
git log --reverse --no-merges $1
}

function dump-log {
rm /tmp/*.gl
cat $1 | while read line;
do
        echo git log $line
        git-log $line > /tmp/$line.gl
done
}

function get-goso-modify {
grep -R "gosomo" . | awk -F ':' '{print $1}' | sort | uniq > goso.mod.br
}
