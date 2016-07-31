" Vim syntax file
" Language:     Cisco IOS "show ip route"
" Last Change:  2008-03-13

if version < 600
        syntax clear
elseif exists("b:current_syntax")
        finish
endif

syn match ciscoIpAddr /\<\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\.\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\.\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\.\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\>/
hi def link ciscoIpAddr Number

syn match ciscoIfName /\<\(Loopback\|Tunnel\|Dialer\)[0-9][0-9]*\>/
syn match ciscoIfName +\<\(Ethernet\|FastEthernet\|ATM\)[0-9][0-9]*/[0-9][0-9]*\(/[0-9][0-9]*\)\?\(\.[0-9][0-9]*\)\?\>+
hi def link ciscoIfName Identifier


syn region ciscoNetwork start=+^.* is \(variably \)\?subnetted+ end=+^.* is \(variably \)\?subnetted+me=s-1 fold contains=ciscoIpAddr,ciscoIfName


set foldmethod=syntax

let b:current_syntax = "ciscoiproute"

" vim: set ts=4

