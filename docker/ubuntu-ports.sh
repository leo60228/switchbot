#!/bin/sh
set -e
sed -i 's/^deb /deb [arch=amd64,i386] /' "$1"
cat >> "$1" << EOF

deb [arch-=amd64,i386] http://ports.ubuntu.com/ubuntu-ports xenial main universe
deb [arch-=amd64,i386] http://ports.ubuntu.com/ubuntu-ports xenial-updates main universe
deb [arch-=amd64,i386] http://ports.ubuntu.com/ubuntu-ports xenial-security main universe
EOF
