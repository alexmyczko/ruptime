#!/bin/bash

CONFIG_PREFIX="${CONFIG_PREFIX:-/etc}"
PREFIX="${PREFIX:-/usr/local}"

mkdir -p "$PREFIX/bin"
install ruptime "$PREFIX/bin/ruptime"

ln -rsf "$PREFIX/bin/ruptime" "$PREFIX/bin/rsw"
ln -rsf "$PREFIX/bin/ruptime" "$PREFIX/bin/rhw"
ln -rsf "$PREFIX/bin/ruptime" "$PREFIX/bin/runame"
ln -rsf "$PREFIX/bin/ruptime" "$PREFIX/bin/rbench"
ln -rsf "$PREFIX/bin/ruptime" "$PREFIX/bin/rboot"
ln -rsf "$PREFIX/bin/ruptime" "$PREFIX/bin/rdisk"
ln -rsf "$PREFIX/bin/ruptime" "$PREFIX/bin/rload"
ln -rsf "$PREFIX/bin/ruptime" "$PREFIX/bin/rnet"
ln -rsf "$PREFIX/bin/ruptime" "$PREFIX/bin/rac"
ln -rsf "$PREFIX/bin/ruptime" "$PREFIX/bin/rwho"

mkdir -p "$PREFIX/share/man/man1"
install man/ruptime.1 "$PREFIX/share/man/man1"

mkdir -p "$CONFIG_PREFIX/ruptime"
cp -n etc/ruptime/* "$CONFIG_PREFIX/ruptime/"

echo "See the Starting it section from README.md to complete the install"
