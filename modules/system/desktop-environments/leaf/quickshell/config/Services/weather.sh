#!/bin/sh

curl "https://api.open-meteo.com/v1/forecast?latitude=0&longitude=0&current=temperature_2m,apparent_temperature,precipitation,weather_code,relative_humidity_2m&daily=temperature_2m_max,temperature_2m_min&temperature_unit=fahrenheit&wind_speed_unit=ms&precipitation_unit=inch"
