#!/bin/sh

#check_dnsbl V1.0
# a bourne shell implementation to check a dns blacklist

if ! [ "$#" -eq 2 ] ; then
  echo "Usage: $0 IP-ADDRESS DNS-BLACK-LIST 
    e.g. $0 192.168.0.1 dnsbl.sorbs.net 
    More lists can be found here: https://en.wikipedia.org/wiki/Comparison_of_DNS_blacklists" 
  exit 1
fi

# Check a DNS blacklist for an IP address and return a Nagios style response

checkstring="echo "\""$1"\"" | awk "\'"BEGIN{FS= "\""."\""}{print "\$"4"\""."\"""\$"3"\""."\"""\$"2"\""."\"""\$"1"\"".$2"\""}"\'" "

host `eval $checkstring` > /dev/null

if [ "$?" -eq 0 ] ; then
 echo "PROBLEM: $1 is listed on $2"
 exit 2
else
 echo "OK: $1 is not listed on $2"
 exit 0
fi

