#!/bin/sh

# Check for security vulnerabilities in host and jails using pkg audit

if ! [ -x /usr/sbin/pkg ]; then
 echo "This system does not have a pkg tool that this script understands"
fi

jailvuln=0
vulnerabilties=`pkg audit | awk 'END{print $1}'`
vulntext=""

for jid in `jls jid`
do
 jailvuln=`pkg -j $jid audit | awk 'END{print $1}'`
 vulnerabilties=$((vulnerabilties+=jailvuln))
 if [ $jailvuln -gt 0 ] ; then
  pkgtext=`pkg -j $jid audit | awk '/vulnerable/ {print $1}' | tr '\n' ' ' `
  vulntext="$vulntext `jls -j $jid name`: $pkgtext"
 fi
done

if [ $vulnerabilties -gt 0 ] ; then
 echo "$vulnerabilties vulnerabilities found: $vulntext"
 exit 2
else
 echo "$vulnerabilties vulnerabilities found."
 exit 0
fi
