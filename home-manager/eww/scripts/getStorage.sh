#!/bin/sh
# !! Unused !!

# Device
device="/dev/nvme0n1p2"

status=$(df -h | grep $device)

size=$(echo $status | awk '{print $2}')
used=$(echo $status | awk '{print $3}')
avail=$(echo $status | awk '{print $4}')
echo $size


