#!/bin/sh

# '| rev | cut -c 2- | rev' from https://linuxhint.com/remove_characters_string_bash/
sensors | grep Package | cut -d ' ' -f 5 | cut -c 2- | rev | cut -c 6- | rev

