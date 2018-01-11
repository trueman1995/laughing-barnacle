#!/bin/bash

for i in $(seq 1 $1); do
  /usr/bin/time -a -o $2 rebuild.sh $i
done