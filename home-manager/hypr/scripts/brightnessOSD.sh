#!/bin/sh



#eww open brightnessOSD;
eww update osd_mode="brightness";
eww update isOSD="true";
sleep 1;
#eww close brightnessOSD;

eww update isOSD="false";
