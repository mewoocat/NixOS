#!/bin/sh


lsdesktopf 2>&1 | grep -v "^#" | grep -v "^grep"
