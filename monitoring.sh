#!/bin/bash

while true
do
    CPU=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'` 
    echo CPU: $CPU
    FREE_DATA=`free -m | grep Mem` 
    CURRENT=`echo $FREE_DATA | cut -f3 -d' '`
    TOTAL=`echo $FREE_DATA | cut -f2 -d' '`
    RAM=$(echo "scale = 2; $CURRENT/$TOTAL*100" | bc)
    echo RAM: $RAM
    echo HDD: `df -lh | awk '{if ($6 == "/") { print $5 }}' | head -1 | cut -d'%' -f1`
    net_interface=`ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}'`
    echo net: $net_interface
    IP_addr=`ifconfig | grep -A 1 $net_interface | tail -1 | awk '{print $2}' | cut -f1  -d'/'`
    echo $IP_addr
    curl -d "$IP_addr, $CPU" http://192.168.122.176:9999
    #curl http://192.168.254.128:9999
    sleep 3
done

