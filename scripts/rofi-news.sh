#!/bin/bash

set -u
set -e

if [[ -z "$@" ]]; then
	# echo "ARY\n92\nBol"
    find $HOME/bin -type f
else
	bash -c $@
fi
