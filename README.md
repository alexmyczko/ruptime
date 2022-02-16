# ruptime
poor man’s ruptime

Historically it is using broadcast udp/513 in a network.
So this is a test how many machines it can take.

## Never heard of ruptime, what does it look like?
```
$ ruptime
fish             up    4+21:27,  0 users,  load 0.22, 0.25, 0.25
tuna             up    4+21:27,  0 users,  load 0.20, 0.25, 0.25
dolphin          up   15+05:57,  0 users,  load 0.04, 0.08, 0.07
```

## Why would I want this?
- monitoring systems have no or not very useful CLI tools
- you don't want to manually keep a list of hosts
- you want to see what hosts are down
- you want to see what hosts are not idle
- you want to run something on all running hosts with `parallel`

## Configuration
The defaults for rwhod/ruptime is downtime after 11' (11\*60 seconds) [1] (ISDOWN), status messages are originally generated approximately every 3' (AL_INTERVAL) [2].
```
yes
```

## Requirements
`nc` `screen` `xz` `tcputils`

## References
[1] https://sources.debian.org/src/netkit-rwho/0.17-14/ruptime/ruptime.c/
[2] https://sources.debian.org/src/netkit-rwho/0.17-14/rwhod/rwhod.c/
