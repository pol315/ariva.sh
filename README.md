# ariva.sh
Android Reverse Interception Via Adb is a helper script to automate adb reverse, as well as iptables rules on a rooted Android phone for the purpose of intercepting traffic via USB.

# Usage
`./ariva.sh init <port>` - initiates the adb reverse and commits iptables rule changes to the USB connected Android device.
`./ariva.sh revert` - reverses the changes made by the script on the USB connected Android device. CAUTION: this will also revert any other custom iptables nat rules. 
