#!/bin/sh

location=$(cat ~/Desktop/weather.txt | awk '{print $1}') 
apiKey=$(cat ~/Desktop/weather.txt | awk '{print $2}')

#current=$(curl -s "http://api.weatherapi.com/v1/current.json?key=${apiKey}&q=${location}")
forecast=$(curl -s "http://api.weatherapi.com/v1/forecast.json?key=${apiKey}&q=${location}")

#echo $current

temp=$(echo $forecast | jq '.current.temp_f')
location=$(echo $forecast | jq '.location.name')
conditions=$(echo $forecast | jq ".current.condition.text")
icon=$(echo $forecast | jq ".current.condition.icon")
pressure=$(echo $forecast | jq ".current.pressure_mb")
humidity=$(echo $forecast | jq ".current.humidity")
highCurrent=$(echo $forecast | jq ".forecast.forecastday[0].day.maxtemp_f")
lowCurrent=$(echo $forecast | jq ".forecast.forecastday[0].day.mintemp_f")

echo "{\"temp\": \"${temp}\", \"location\": ${location}, \"conditions\": ${conditions}, \"pressure\": ${pressure}, \"humidity\": ${humidity}, \"highCurrent\": ${highCurrent}, \"lowCurrent\": ${lowCurrent} }"


