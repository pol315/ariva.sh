#!/bin/bash

# ariva.sh - Android Reverse Interception Via Adb

# $1 will be init or revert
# init will take $2 as the reverse port and construct the reverse connection
# revert will reset adb and iptables rules

printHelp()
{
    echo "Usage: ariva.sh init <port>"
    echo "       ariva.sh revert"
    echo ""
    echo "Caution!: This will make changes to the iptables rules on the connected phone. Reverting will delete ALL RULES. Backup any custom rules first."
}

startInit()
{
    adb reverse tcp:$1 tcp:$1
    adb shell "su -c iptables -t nat -F"
    adb shell "su -c iptables -t nat -A OUTPUT -p tcp --dport 80 -j DNAT --to-destination 127.0.0.1:$1"
    adb shell "su -c iptables -t nat -A OUTPUT -p tcp --dport 443 -j DNAT --to-destination 127.0.0.1:$1"
    adb shell "su -c iptables -t nat -A POSTROUTING -p tcp --dport 80 -j MASQUERADE"
    adb shell "su -c iptables -t nat -A POSTROUTING -p tcp --dport 443 -j MASQUERADE"
    echo "Reverse interception started on port $1..."
}

startRevert()
{
    adb reverse --remove-all
    adb shell "su -c iptables -t nat -F"
    echo "Interception rules have been reverted..."
}

if [ $# -eq 0 ]
then
    printHelp
    exit 0
fi

if [ $1 == "init" ]
then
    if [ $# -ne 2 ]
    then
        echo "Incorrect number of arguments. Exiting..."
        exit 1
    else
        startInit $2
    fi
elif [ $1 == "revert" ]
then
    if [ $# -ne 1 ]
    then
        echo "Incorrect number of arguments. Exiting..."
        exit 1
    else
        startRevert
    fi
else
    echo "Incorrect first argument, must be \"init\" or \"revert\". Exiting..."
    exit 1
fi