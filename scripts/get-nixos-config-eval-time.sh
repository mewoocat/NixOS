#!/bin/sh

NIX_SHOW_STATS=1 nix eval --file . obsidian.config.system.build.toplevel --no-eval-cache | grep cpuTime
