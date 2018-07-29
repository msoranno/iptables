#!/usr/bin/env bash

NOW=`date '+%Y-%m-%d %H:%M:%S'`
save_file="iptables-save_$NOW"

echo ; echo  "Please run me as sudo" ; echo

echo ; echo  "Saving current configuration on $save_file"
iptables-save > $save_file

# --
# - Flush (-F) do not close current connections
#--

echo ; echo "Cleaning firewall"
echo "filter table"
iptables -F -t filter
echo "nat table"
iptables -F -t nat
echo "counters"
iptables -Z

#--
# Manage
#--

echo ; echo "Setting trafic forward between interfaces"
echo 1 > /proc/sys/net/ipv4/ip_forward

echo ; echo "Setting default policies Deny ALL"
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

echo ; echo "Enable loopback interface"
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

echo ;  echo "Handle Sessions"



#--
# Custom rules
#--

echo ; echo "Accepting connections from local network"
iptales -t filter -A INPUT -s 192.168.1.0/24 -p tcp --dport 22 -j ACCEPT
iptales -t filter -A OUTPUT -p tcp --sport 22 -j ACCEPT

echo ; echo "Accepting WEB"
