#!/bin/bash

hg qrefresh
hg qpop -a
hg pull
hg update