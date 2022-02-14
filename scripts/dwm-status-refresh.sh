#!/usr/bin/bash

#################################################
# File Name dwm-status-refresh.sh
# Version 1.0
# Author aaron
# Email wzj020109@163.com
# Created Time 2022-01-27
#################################################


print_bat(){
    echo "$(get_battery_charging_status) $(get_battery_combined_percent)%";
}

get_battery_combined_percent() {
    # get charge of all batteries, combine them
    total_charge=$(acpi -b | awk '{print $4}' | grep -Eo "[0-9]+" | paste -sd+);
    echo $total_charge;
}

get_battery_charging_status() {
    total_charge=$(get_battery_combined_percent)
    if $(acpi -b | grep --quiet Discharging);then
        if [[ $total_charge -eq "100" ]]; then
            echo 
        elif [[ $total_charge -ge "90" ]]; then
            echo 
        elif [[ $total_charge -ge "80" ]]; then
            echo 
        elif [[ $total_charge -ge "70" ]]; then
            echo 
        elif [[ $total_charge -ge "60" ]]; then
            echo 
        elif [[ $total_charge -ge "50" ]]; then
            echo 
        elif [[ $total_charge -ge "40" ]]; then
            echo 
        elif [[ $total_charge -ge "30" ]]; then
            echo 
        elif [[ $total_charge -ge "20" ]]; then
            echo 
            dunstify "电量: $(total_charge)% 电量过低, 插入电源"
        elif [[ $total_charge -ge "10" ]]; then
            echo 
            dunstify "电量: $(total_charge)% 电量过低, 插入电源"
        fi
    else
        echo 
    fi
}

get_volume_status() {
    VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
    if [ "$VOL" -eq 0 ]; then
        echo 🔇 $VOL%
    elif [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
        echo 🔈 $VOL%
    elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
        echo 🔉 $VOL%
    else
        echo 🔊 $VOL%
    fi
}

print_date(){
    echo 📆 $(date '+%y/%m/%d %A %H:%M')
}

# get_xbacklight_status() {
    # xl=$(xbacklight -get)
    # echo 盛 ${xl%.*}%
# }

get_user() {
    echo  $(who | awk '{print $1}')
}

get_wifi() {
  wifi=$(iwctl known-networks list | awk 'NR==5 {print $1}')
  echo  $wifi
}


LOC=$(readlink -f "$0")
DIR=$(dirname "$LOC")
export IDENTIFIER="unicode"

xsetroot -name "$(get_user) | $(get_volume_status) | $(print_bat) | $(get_wifi) | $(print_date)"

exit 0
