#!/bin/sh

location=$(cat ~/Desktop/weather.txt | awk '{print $1}') 
units=$(cat ~/Desktop/weather.txt | awk '{print $2}')
apikey=$(cat ~/Desktop/weather.txt | awk '{print $3}')

data=$(curl -s "http://api.openweathermap.org/data/2.5/weather?q=${location}&appid=${apikey}&units=${units}")

temp=$(echo $data | jq '.main.temp')
location=$(echo $data | jq '.name')
conditions=$(echo $data | jq ".weather[0].main")
pressure=$(echo $data | jq ".main.pressure")
humidity=$(echo $data | jq ".main.humidity")

echo "{\"temp\": \"${temp}\", \"location\": ${location}, \"conditions\": ${conditions}}"


