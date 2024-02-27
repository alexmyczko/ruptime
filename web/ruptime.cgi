#!/bin/bash

echo -e "Content-type: text/html\n\n";

cat << EOF
<title>RUPTIME</title>
<meta http-equiv="Refresh" content="60">
<style type="text/css"><!--
@font-face
{ font-family: agave;
  src: url('agave-r-autohinted.woff2') format("truetype"); }
a, :visited, :link { color: red; }
body,tt,pre {
font-family: agave, sans-serif;
}

.topright {
  position: absolute;
  top: 8px;
  right: 8px;
}

.bottomright {
  position: fixed;
  bottom: 8px;
  right: 8px;
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
cat << TOPRIGHT
<div class="topright">
<a href="?query=stats">stats</a>
</div>
TOPRIGHT
cat << BOTTOMRIGHT
<div class="bottomright">
<a href="https://github.com/alexmyczko/ruptime/"><img src="https://raw.githubusercontent.com/alexmyczko/ruptime/debian/.ruptime.png" height=16></a>
</div>
BOTTOMRIGHT
echo "<pre>"
$run
echo "<br>"
