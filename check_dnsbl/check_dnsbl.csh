#!/bin/csh

#check_dnsbl V1.0
# a csh implementation to check a dns blacklist

if ( "$#" != 2 ) then
  echo "Usage: $0 IP-ADDRESS DNS-BLACK-LIST \n \
    e.g. $0 192.168.0.1 dnsbl.sorbs.net \n \
    More lists can be found here: https://en.wikipedia.org/wiki/Comparison_of_DNS_blacklists" 
  exit 1
endif

# Check a DNS blacklist for an IP address and return a Nagios style response

set lc="{"
set rc="}"
set checkstring = `eval "echo "\""$1"\"" | awk "\'"BEGIN $lc FS= "\""."\"" $rc $lc print "\$"4"\""."\"""\$"3"\""."\"""\$"2"\""."\"""\$"1"\"".$2"\"" $rc "\'" "`

host $checkstring > /dev/null

if ( $status == 0 ) then
 echo "PROBLEM: $1 is listed on $2"
 exit 2
else
 echo "OK: $1 is not listed on $2"
 exit 0
endif
