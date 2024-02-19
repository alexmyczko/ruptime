#!/bin/bash

echo -e "Content-type: text/html\n\n";

cat << EOF
<style type="text/css"><!--
@font-face
{ font-family: agave;
  src: url('agave-r-autohinted.woff2') format("truetype"); }
a, :visited, :link { color: red; }
body,tt,pre {
font-family: agave, sans-serif;
}

:root {
  --text: #000;
  --bg: #fff;
}
body {
  background-color: var(--bg);
  color: var(--text);
}
@media (prefers-color-scheme: dark) {
  :root {
    --text: #fff;
    --bg: #000;
  }
}
-->
</style>
EOF
echo "<tt>"
sel=$(echo $QUERY_STRING | sed "s,.*=,,")
for a in $(grep ruptime /usr/bin/ruptime  |head -1 |sed "s,.*in ,,;s,;.*,,"); do
    echo "<a href=?query=$a>$a</a>"
    if [ "$a" = "$sel" ]; then
	run=$a
    fi
done
echo "<pre>"
$run
echo "<br>"
