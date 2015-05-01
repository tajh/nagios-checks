#!/bin/csh

# Check for security vulnerabilities in host and jails using pkg audit

if !( -x /usr/sbin/pkg ) then
 echo "This system does not have a pkg tool that this script understands"
endif

set jailvuln = 0
set vulnerabilties = `pkg audit | awk 'END{print $1}'`
set vulntext = ""

foreach jid ( `jls jid` )
 @ jailvuln = `pkg -j $jid audit | awk 'END{print $1}'`
 @ vulnerabilties =  $vulnerabilties + $jailvuln
 if ( $jailvuln >0 ) then
  set pkgtext = `pkg -j $jid audit | awk '/vulnerable/ {print $1}' | tr '\n' ' ' `
  set vulntext = "$vulntext `jls -j $jid name`: $pkgtext"
 endif
end

if ( $vulnerabilties > 0 ) then
 echo "$vulnerabilties vulnerabilities found: $vulntext"
 exit 2
else
 echo "$vulnerabilties vulnerabilities found."
 exit 0
endif
