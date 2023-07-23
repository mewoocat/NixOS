#!/bin/sh

GLOBIGNORE="*"
ssids=()
statuses=()
strengths=()
nmcli -g common dev wifi list > ~/.config/eww/scripts/networks.txt 

# { "number": "1", "status": "test", "color": "current" }
while read -r network
do
    # Get first column
    firstColumn="$(echo "$network" | cut -d ':' -f 1)"

    # Check if connect to network
    if [ "$firstColumn" == "*" ]; then
        status="Connected"
    else
        status="Disconnected"
    fi

    # Get ssid
    ssid="$(echo "$network" | cut -d ':' -f 8)"

    # Get strength
    strength=$(echo "$network" | cut -d ':' -f 12)
    #strength=$(expr $s)
    #echo $strength

    #strength=60

    # Set icons
    icon_bg=""

    if (( $strength > 75 )); then
        #echo "7 $ssid"
        icon=""
    elif (( $strength > 50 )); then
        #echo "5 $ssid"
        icon=""
    elif (( $strength > 25 )); then
        #echo "2 $ssid"
        icon=""
    #else
    elif (( $strength <= 25 )); then
        #echo "huh $ssid"
        icon=""
        #icon=""
    fi



    exists=false
    for i in "${!ssids[@]}"
    do
        #echo "$ssid"
        #echo "${ssids[$i]}"
        if [ "$ssid" == "${ssids[$i]}" ]; then
            if [ "${status[$i]}" == "Connected" ]; then
                statuses[$i]="Connected"
            fi
            exists=true
            #echo "${ssid} exits"
        fi
    done
 
    #echo "status of $ssid: $status"

    #if [[ $exists == false && $ssid != "" ]]
    if [ true ]
    then
        ssids+=("$ssid")
        statuses+=("$status")
        strengths+=("$strength")
    fi

done < ~/.config/eww/scripts/networks.txt 


echo -n '['
for i in "${!ssids[@]}"
do
    if [ $(($i+1)) != ${#ssids[@]} ]; then
        echo -n "{ \""ssid"\": \"${ssids[$i]}\", \""status"\": \"${statuses[$i]}\", \""strength"\": \"${strengths[$i]}\", \""icon"\": \"$icon\", \""icon_bg"\": \"$icon_bg\"},"
    else
        echo -n "{ \""ssid"\": \"${ssids[$i]}\", \""status"\": \"${statuses[$i]}\", \""strength"\": \"${strengths[$i]}\", \""icon"\": \"$icon\", \""icon_bg"\": \"$icon_bg\"}"

    fi
done
echo ']'




