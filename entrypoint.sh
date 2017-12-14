#!/bin/sh

if [ -z "$1" ] ; then
	echo "SYSTEM not specified; must be one of: bpim2p, bx2, opi2, opilite, opione, opipc, opipcplus, opiplus2e, opiplus"
	exit 1
fi

export SYSTEM="$1"

shift

make image $@

