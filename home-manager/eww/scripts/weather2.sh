#!/bin/sh

online=false

#location=$(cat ~/Desktop/weather.txt | awk '{print $1}') 
#apiKey=$(cat ~/Desktop/weather.txt | awk '{print $2}')

#current=$(curl -s "http://api.weatherapi.com/v1/current.json?key=${apiKey}&q=${location}")
forecast=$(curl -s "http://api.weatherapi.com/v1/forecast.json?key=${apiKey}&q=${location}")

if [[ online == true ]];
then
  
  temp=$(echo $forecast | jq '.current.temp_f')
  location=$(echo $forecast | jq '.location.name')
  conditions=$(echo $forecast | jq ".current.condition.text")
  icon=$(echo $forecast | jq ".current.condition.icon")
  pressure=$(echo $forecast | jq ".current.pressure_mb")
  humidity=$(echo $forecast | jq ".current.humidity")
  highCurrent=$(echo $forecast | jq ".forecast.forecastday[0].day.maxtemp_f")
  lowCurrent=$(echo $forecast | jq ".forecast.forecastday[0].day.mintemp_f")

else

  temp=$(echo "offline")
  location=$(echo "b")
  conditions=$(echo "a")
  icon=$(echo "a")
  pressure=$(echo "a")
  humidity=$(echo "a")
  highCurrent=$(echo "a")
  lowCurrent=$(echo "a")

fi

#echo "{\"temp\": \"${temp}\", \"location\": ${location}, \"conditions\": ${conditions}, \"pressure\": ${pressure}, \"humidity\": ${humidity}, \"highCurrent\": ${highCurrent}, \"lowCurrent\": ${lowCurrent} }"
echo "{\"temp\": \"${temp}\", \"location\": \"${location}\", \"conditions\": \"${conditions}\", \"pressure\": \"${pressure}\", \"humidity\": \"${humidity}\", \"highCurrent\": \"${highCurrent}\", \"lowCurrent\": \"${lowCurrent}\", \"online\": \"${online}\"  }"


