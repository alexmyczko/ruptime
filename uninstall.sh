#!/bin/bash

CONFIG_PREFIX="${CONFIG_PREFIX:-/etc}"
PREFIX="${PREFIX:-/usr/local}"

rm -f "$PREFIX/bin/ruptime"
rm -f "$PREFIX/bin/rhw"
rm -f "$PREFIX/bin/runame"
rm -f "$PREFIX/bin/rbench"
rm -f "$PREFIX/bin/rboot"
rm -f "$PREFIX/bin/rdisk"
rm -f "$PREFIX/bin/rload"
rm -f "$PREFIX/bin/rnet"
rm -f "$PREFIX/bin/rac"
rm -f "$PREFIX/bin/rwho"

echo "Config files may remain in $CONFIG_PREFIX"
echo "Undo the Starting it section from README.md manually."
