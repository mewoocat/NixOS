#!/bin/sh

cat /proc/net/wireless | grep wlp1s0 | cut -d ' ' -f 6 | tr -d .
