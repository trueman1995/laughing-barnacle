#!/bin/bash

make distclean
./start
if [[ -n $1 ]]; then
	make -j $1
else
	make -j 12
fi
